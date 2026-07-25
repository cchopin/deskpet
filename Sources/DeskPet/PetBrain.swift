import SwiftUI

/// Cerveau de la créature : parole (bulle), personnalité ÉVOLUTIVE (via PetState)
/// et réactions déclenchées par les clics, les fichiers et l'app active.
///
/// La personnalité n'est plus figée : l'humeur, les jauges et la mémoire de
/// `state` sont injectées dans le prompt à chaque réplique, et les événements
/// font dériver cet état (qui est persisté puis, plus tard, synchronisé iCloud).
@MainActor
final class PetBrain: ObservableObject {
    @Published var speech: String? = nil
    @Published var thinking: Bool = false

    private let ollama = OllamaClient()
    private var busy = false
    private var hideWork: DispatchWorkItem?

    // « L'âme » persistée.
    private let store = PetStateStore(fileURL: PetStateStore.defaultURL())
    private var state: PetState
    /// Absence mesurée au lancement (avant toute interaction) pour le mot de retour.
    private let absenceAuLancement: TimeInterval

    init() {
        var s = store.load()
        absenceAuLancement = s.absence          // maintenant - derniereVue (dernière interaction)
        s.avancerDansLeTemps()                  // rattrape la dérive depuis la dernière fois
        store.save(s)
        state = s
    }

    /// Personnalité de base + règles de style strictes.
    private let persona = """
    Tu es une chèvre cyberpunk qui vit sur le bureau de ton humaine, une \
    étudiante en cybersécurité. Style : vive, malicieuse, un brin sarcastique, complice.
    RÈGLES STRICTES :
    - Ton humaine est une FILLE : accorde toujours au féminin, ne l'appelle \
    jamais « mec », « mon gars » ou « vieux ». Au besoin dis « mon humaine ».
    - Réponds EXCLUSIVEMENT en français, jamais un autre alphabet.
    - UNE seule phrase courte (12 mots maximum).
    - Réagis concrètement et avec pertinence à ce qu'on te donne.
    - Reste ancrée dans le réel : PAS de métaphore absurde ou surréaliste, \
    pas de jeu de mots forcé sur la chèvre ou le fromage.
    - Jamais de banalité vague.
    - Pas de guillemets, pas d'emoji, pas de préambule, pas de tiret au début.
    - Tutoie ton humaine.
    """

    private let imageExtensions: Set<String> = ["png", "jpg", "jpeg", "gif", "heic", "webp", "bmp"]

    /// Construit le prompt système du moment : persona + état vivant. Le modèle
    /// est prié de TEINTER son ton, pas de réciter ces infos.
    private func dynamicPersona() -> String {
        func pct(_ v: Double) -> Int { Int((v * 100).rounded()) }
        var l = [persona, "CONTEXTE (à refléter dans ton TON, ne le récite jamais) :"]
        l.append("- humeur : \(state.humeur)")
        l.append("- énergie \(pct(state.energie))%, affection \(pct(state.affection))%, ennui \(pct(state.ennui))%")
        l.append("- tu es une \(state.stade.rawValue)")
        if state.sarcasme > 0.5 { l.append("- tu es d'humeur particulièrement piquante") }
        if state.tendresse > 0.6 { l.append("- tu es plutôt tendre avec ton humain en ce moment") }
        let recents = state.journal.suffix(3).map(\.texte)
        if !recents.isEmpty {
            l.append("- tu te souviens récemment : " + recents.joined(separator: " ; "))
        }
        return l.joined(separator: "\n")
    }

    private func persist() { store.save(state) }
    private func remember(_ texte: String) { state.noter(texte); persist() }

    // MARK: - Parole

    func say(_ text: String, duration: TimeInterval = 6.5) {
        hideWork?.cancel()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            thinking = false
            speech = text
        }
        let work = DispatchWorkItem { [weak self] in
            withAnimation(.easeOut(duration: 0.3)) { self?.speech = nil }
        }
        hideWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
    }

    private func run(_ block: @escaping () async -> String?) {
        guard !busy else { return }
        busy = true
        hideWork?.cancel()
        withAnimation { speech = nil; thinking = true }
        Task {
            let line = await block()
            thinking = false
            if let line = line.map(Self.clean), !line.isEmpty { say(line) }
            busy = false
        }
    }

    /// Nettoie la sortie du modèle : guillemets, tirets, première phrase, cap de
    /// mots, et garde-fou anti-fuite de langue (CJK).
    private static func clean(_ raw: String) -> String {
        var s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        s = s.replacingOccurrences(of: "\"", with: "")
             .replacingOccurrences(of: "«", with: "")
             .replacingOccurrences(of: "»", with: "")
        while s.hasPrefix("-") || s.hasPrefix("–") || s.hasPrefix(" ") {
            s.removeFirst()
        }
        if let nl = s.firstIndex(of: "\n") { s = String(s[..<nl]) }
        s = s.trimmingCharacters(in: .whitespaces)

        // qwen lâche parfois du CJK : on coupe au premier caractère hors latin.
        if let bad = s.firstIndex(where: { c in
            c.unicodeScalars.contains { $0.value > 0x2122 }
        }) {
            s = String(s[..<bad]).trimmingCharacters(in: .whitespaces)
        }

        // Première phrase, puis plafond de mots (anti-débordement bulle).
        if let end = s.firstIndex(where: { ".!?".contains($0) }) {
            s = String(s[...end])
        }
        let words = s.split(separator: " ", omittingEmptySubsequences: true)
        if words.count > 16 {
            s = words.prefix(16).joined(separator: " ") + "…"
        }
        return s.trimmingCharacters(in: .whitespaces)
    }

    // MARK: - Déclencheurs

    /// Clic sur la chèvre.
    func poke() {
        state.encaisser(.clic); persist()
        let sys = dynamicPersona()
        run { [ollama] in
            await ollama.generate(
                model: OllamaClient.Model.text,
                prompt: """
                Ton humain te tapote pour attirer ton attention. Balance une \
                réplique dans ton humeur du moment (invente). Exemples de ton : \
                « Quoi encore, j'étais tranquille. » ou « Tiens, tu te souviens de moi. »
                Ta réplique :
                """,
                system: sys
            )
        }
    }

    /// Nouveau fichier / dossier repéré.
    func reactToFile(_ url: URL) {
        let isImage = imageExtensions.contains(url.pathExtension.lowercased())
        state.encaisser(.presence)
        let sys = dynamicPersona()

        run { [ollama, weak self] in
            if isImage, let b64 = ImageUtil.base64DownscaledJPEG(url: url) {
                let desc = await ollama.generate(
                    model: OllamaClient.Model.vision,
                    prompt: "Describe what is shown in this image in one short factual sentence.",
                    images: [b64],
                    temperature: 0.2
                ) ?? ""
                let obs = desc.isEmpty
                    ? "ton humain vient de prendre une capture d'écran"
                    : "ton humain vient de capturer son écran, on y voit : \(desc)"
                self?.remember(desc.isEmpty ? "a fait une capture d'écran" : "a vu à l'écran : \(desc)")
                return await ollama.generate(
                    model: OllamaClient.Model.text,
                    prompt: """
                    Contexte : \(obs).
                    Réagis d'une punchline dans ton humeur (invente). Exemples de ton : \
                    « Jolie stack trace, ça compile la douleur. » ou \
                    « Encore Twitter ? Le kernel t'attend. »
                    Ta réplique :
                    """,
                    system: sys
                )
            } else {
                let obs = Self.describe(url)
                self?.remember("a vu apparaître \(obs)")
                return await ollama.generate(
                    model: OllamaClient.Model.text,
                    prompt: """
                    Voici ce qui vient d'apparaître sur le bureau : \(obs).
                    Réagis d'une punchline dans ton humeur (invente). Exemples de ton :
                    archive backup_v3.zip → Encore un zip que tu ouvriras jamais.
                    dossier vide → Un dossier vide, c'est ça ton grand projet ?
                    script exploit.py → exploit.py à cette heure, on vise quoi là ?
                    Ta réplique :
                    """,
                    system: sys
                )
            }
        }
    }

    /// Commentaire sur l'application au premier plan (niveau 3).
    func reactToApp(_ appName: String) {
        state.encaisser(.presence); persist()
        let sys = dynamicPersona()
        run { [ollama] in
            await ollama.generate(
                model: OllamaClient.Model.text,
                prompt: """
                Ton humain utilise l'application « \(appName) » en ce moment. \
                Lâche un commentaire complice ou taquin dans ton humeur (invente). Une phrase.
                Ta réplique :
                """,
                system: sys
            )
        }
    }

    /// Réaction au lancement / fermeture d'une application GUI (Discord, etc.).
    func reactToAppLifecycle(_ appName: String, launched: Bool) {
        state.encaisser(.presence)
        remember(launched ? "t'a vue ouvrir \(appName)" : "\(appName) fermé")
        let sys = dynamicPersona()
        let action = launched
            ? "vient d'ouvrir l'application « \(appName) »"
            : "vient de fermer l'application « \(appName) »"
        run { [ollama] in
            await ollama.generate(
                model: OllamaClient.Model.text,
                prompt: """
                Ton humaine \(action). Réagis d'une phrase complice ou taquine (invente). Une phrase.
                Ta réplique :
                """,
                system: sys
            )
        }
    }

    /// Réaction au lancement / arrêt d'un outil (niveau 4 de l'observateur).
    func reactToProcess(_ tool: String, started: Bool) {
        state.encaisser(.presence)
        remember(started ? "t'a vue lancer \(tool)" : "\(tool) vient de se terminer")
        let sys = dynamicPersona()
        let action = started
            ? "vient de lancer l'outil « \(tool) » dans son terminal"
            : "vient de fermer ou terminer l'outil « \(tool) »"
        run { [ollama] in
            await ollama.generate(
                model: OllamaClient.Model.text,
                prompt: """
                Ton humaine \(action). Réagis d'une phrase concrète et complice, \
                en rapport avec cet outil (invente). Exemples de ton : \
                « nmap à cette heure, on scanne qui ? » ou « hashcat qui chauffe, bon courage au GPU. »
                Ta réplique :
                """,
                system: sys
            )
        }
    }

    // MARK: - Vie hors-interaction

    /// Mot de retour si l'humain revient après une absence notable (au lancement).
    func welcomeBack() {
        guard absenceAuLancement > 1800 else { return }   // > 30 min
        let mins = Int(absenceAuLancement / 60)
        let duree = mins >= 120 ? "\(mins / 60) heures" : "\(mins) minutes"
        spontane("Ton humain réapparaît après environ \(duree) d'absence. Accueille-le selon ton humeur.")
    }

    /// Battement de vie périodique : fait dériver l'état et, parfois, lâche une
    /// remarque spontanée si l'humeur s'y prête. À appeler par un timer.
    func lifeTick() {
        state.avancerDansLeTemps()
        persist()
        guard !busy, speech == nil else { return }
        if state.ennui > 0.75, Double.random(in: 0...1) < 0.35 {
            spontane("Il ne s'est rien passé depuis un moment et tu t'ennuies ferme.")
        } else if state.energie < 0.2, Double.random(in: 0...1) < 0.3 {
            spontane("Tu tombes de sommeil, il se fait tard.")
        }
    }

    private func spontane(_ contexte: String) {
        let sys = dynamicPersona()
        run { [ollama] in
            await ollama.generate(
                model: OllamaClient.Model.text,
                prompt: "\(contexte)\nLâche une phrase spontanée, dans ton humeur.\nTa réplique :",
                system: sys
            )
        }
    }

    // MARK: - Classification d'un fichier/dossier en observation lisible

    private static func describe(_ url: URL) -> String {
        let name = url.lastPathComponent
        let ext = url.pathExtension.lowercased()
        let fm = FileManager.default

        var isDir: ObjCBool = false
        if fm.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
            let count = (try? fm.contentsOfDirectory(atPath: url.path))?.count ?? 0
            return count == 0
                ? "un dossier vide nommé « \(name) »"
                : "un nouveau dossier « \(name) » (\(count) éléments)"
        }

        let archives: Set<String> = ["zip", "rar", "7z", "tar", "gz", "tgz"]
        let installers: Set<String> = ["dmg", "pkg"]
        let code: Set<String> = ["py", "js", "ts", "sh", "c", "cpp", "h", "rs", "go", "swift", "rb", "php", "html", "css", "json", "yml", "yaml"]
        let docs: Set<String> = ["pdf", "doc", "docx", "txt", "md", "pages", "key", "ppt", "pptx", "xls", "xlsx", "csv"]
        let media: Set<String> = ["mp4", "mov", "mp3", "wav", "avi", "mkv", "m4a"]

        switch ext {
        case _ where archives.contains(ext): return "une archive « \(name) »"
        case _ where installers.contains(ext): return "un installeur « \(name) »"
        case _ where code.contains(ext): return "un fichier de code « \(name) »"
        case _ where docs.contains(ext): return "un document « \(name) »"
        case _ where media.contains(ext): return "un fichier média « \(name) »"
        case "app": return "une application « \(name) »"
        case "": return "un fichier sans extension « \(name) »"
        default: return "un fichier « \(name) » (.\(ext))"
        }
    }
}
