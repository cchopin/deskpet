import SwiftUI

/// Cerveau de la créature : parole (bulle), personnalité ÉVOLUTIVE (via PetState)
/// et réactions déclenchées par les clics, les fichiers et l'app active.
///
/// La personnalité n'est plus figée : l'humeur, les jauges et la mémoire de
/// `state` teintent le CHOIX des répliques à chaque événement, et les événements
/// font dériver cet état (persisté puis, plus tard, synchronisé iCloud).
///
/// Les répliques sont désormais SCRIPTÉES (voir `ScriptedLines`) et non plus
/// générées par un modèle local : instantané, léger, et calibré au ton voulu.
@MainActor
final class PetBrain: ObservableObject {
    @Published var speech: String? = nil
    /// Conservé pour l'UI (SpeechBubble) : le scripté étant instantané, on ne
    /// passe plus jamais par un état « réfléchit ».
    @Published var thinking: Bool = false

    private var picker = ScriptedLines.Picker()
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

    private let imageExtensions: Set<String> = ["png", "jpg", "jpeg", "gif", "heic", "webp", "bmp"]

    /// Humeur du moment mappée pour le choix des répliques.
    private var mood: ScriptedLines.Mood { ScriptedLines.Mood(state.humeur) }
    private var piquante: Bool { state.sarcasme > 0.5 }

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

    /// Pioche une réplique dans un pool et l'affiche.
    private func speak(_ pool: [String]) {
        say(picker.pick(pool))
    }

    // MARK: - Déclencheurs

    /// Clic sur la chèvre. Le pool mêle son humeur et le moment de la journée
    /// (faim vers midi, coup de mou l'après-midi, bâillements le soir).
    func poke() {
        state.encaisser(.clic); persist()
        speak(ScriptedLines.poke(mood: mood, piquante: piquante, slot: ScriptedLines.TimeSlot()))
    }

    /// Nouveau fichier / dossier repéré.
    func reactToFile(_ url: URL) {
        let isImage = imageExtensions.contains(url.pathExtension.lowercased())
        state.encaisser(.presence)

        if isImage {
            remember("a fait une capture ou déposé une image")
            speak(ScriptedLines.file(.image(nom: url.lastPathComponent)))
        } else {
            let kind = Self.classify(url)
            remember("a vu apparaître \(Self.describe(kind))")
            speak(ScriptedLines.file(kind))
        }
    }

    /// Commentaire sur l'application au premier plan (niveau 3).
    func reactToApp(_ appName: String) {
        state.encaisser(.presence); persist()
        speak(ScriptedLines.app(appName, event: .focus))
    }

    /// Réaction au lancement / fermeture d'une application GUI (Discord, etc.).
    func reactToAppLifecycle(_ appName: String, launched: Bool) {
        state.encaisser(.presence)
        remember(launched ? "t'a vue ouvrir \(appName)" : "\(appName) fermé")
        speak(ScriptedLines.app(appName, event: launched ? .launch : .quit))
    }

    /// Réaction au lancement / arrêt d'un outil (niveau 4 de l'observateur).
    func reactToProcess(_ tool: String, started: Bool) {
        state.encaisser(started ? .vuErreurCode : .presence)
        remember(started ? "t'a vue lancer \(tool)" : "\(tool) vient de se terminer")
        speak(ScriptedLines.tool(tool.lowercased(), started: started))
    }

    // MARK: - Vie hors-interaction

    /// Mot de retour si elle revient après une absence notable (au lancement).
    func welcomeBack() {
        guard absenceAuLancement > 1800 else { return }   // > 30 min
        let mins = Int(absenceAuLancement / 60)
        let duree = mins >= 120 ? "\(mins / 60) heures" : "\(mins) minutes"
        speak(ScriptedLines.welcomeBack(duree: duree))
    }

    /// Battement de vie périodique : fait dériver l'état et, parfois, lâche une
    /// remarque spontanée si l'humeur s'y prête. À appeler par un timer.
    func lifeTick() {
        state.avancerDansLeTemps()
        persist()
        guard speech == nil else { return }
        if state.ennui > 0.75, Double.random(in: 0...1) < 0.35 {
            speak(ScriptedLines.bored())
        } else if state.energie < 0.2, Double.random(in: 0...1) < 0.3 {
            speak(ScriptedLines.tired())
        } else if Double.random(in: 0...1) < 0.06 {
            // Remarque d'ambiance liée à l'heure, environ toutes les 25 minutes.
            speak(ScriptedLines.TimeSlot().lines)
        }
    }

    // MARK: - Classification d'un fichier/dossier

    private static func classify(_ url: URL) -> ScriptedLines.FileKind {
        let name = url.lastPathComponent
        let ext = url.pathExtension.lowercased()
        let fm = FileManager.default

        var isDir: ObjCBool = false
        if fm.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
            let count = (try? fm.contentsOfDirectory(atPath: url.path))?.count ?? 0
            return count == 0 ? .dossierVide(nom: name) : .dossier(nom: name, count: count)
        }

        let archives: Set<String> = ["zip", "rar", "7z", "tar", "gz", "tgz"]
        let installers: Set<String> = ["dmg", "pkg"]
        let code: Set<String> = ["py", "js", "ts", "sh", "c", "cpp", "h", "rs", "go", "swift", "rb", "php", "html", "css", "json", "yml", "yaml"]
        let docs: Set<String> = ["pdf", "doc", "docx", "txt", "md", "pages", "key", "ppt", "pptx", "xls", "xlsx", "csv"]
        let media: Set<String> = ["mp4", "mov", "mp3", "wav", "avi", "mkv", "m4a"]

        switch ext {
        case _ where archives.contains(ext):   return .archive(nom: name)
        case _ where installers.contains(ext): return .installeur(nom: name)
        case _ where code.contains(ext):       return .code(nom: name)
        case _ where docs.contains(ext):       return .document(nom: name)
        case _ where media.contains(ext):      return .media(nom: name)
        case "app":                            return .application(nom: name)
        case "":                               return .sansExtension(nom: name)
        default:                               return .autre(nom: name, ext: ext)
        }
    }

    /// Description lisible d'une catégorie, pour le journal de souvenirs.
    private static func describe(_ kind: ScriptedLines.FileKind) -> String {
        switch kind {
        case let .dossierVide(nom):      return "un dossier vide « \(nom) »"
        case let .dossier(nom, count):   return "un dossier « \(nom) » (\(count) éléments)"
        case let .archive(nom):          return "une archive « \(nom) »"
        case let .installeur(nom):       return "un installeur « \(nom) »"
        case let .code(nom):             return "un fichier de code « \(nom) »"
        case let .document(nom):         return "un document « \(nom) »"
        case let .media(nom):            return "un fichier média « \(nom) »"
        case let .image(nom):            return "une image « \(nom) »"
        case let .application(nom):      return "une application « \(nom) »"
        case let .sansExtension(nom):    return "un fichier sans extension « \(nom) »"
        case let .autre(nom, ext):       return "un fichier « \(nom) » (.\(ext))"
        }
    }
}
