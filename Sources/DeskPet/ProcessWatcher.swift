import Foundation

/// Niveau 4 de l'observateur : surveille le LANCEMENT et l'ARRÊT de process
/// « intéressants » (outils sécu / dev). À chaque tick on liste les noms de
/// commande (`ps -axo comm`) et on diffe avec le tick précédent.
///
/// Le scan tourne sur une file série dédiée (le `ps` ne bloque pas l'UI) ; les
/// callbacks sont renvoyés sur le thread principal.
final class ProcessWatcher {
    enum Event { case started, ended }

    /// (nom d'outil, démarré ?) — démarré=false signifie terminé/fermé.
    var onEvent: ((String, Event) -> Void)?

    private let interval: TimeInterval = 6
    private let cooldown: TimeInterval = 12
    private let queue = DispatchQueue(label: "deskpet.procwatcher")
    private var timer: Timer?

    private var known: Set<String> = []
    private var firstScan = true
    private var lastFired: [String: Date] = [:]

    /// Outils qu'on juge dignes d'un commentaire (basename de commande, minuscule).
    /// On évite volontairement python/node/git/ssh : trop fréquents → spam.
    private let watch: Set<String> = [
        // Sécurité / réseau
        "nmap", "masscan", "tcpdump", "tshark", "wireshark", "sqlmap", "hydra",
        "hashcat", "john", "gobuster", "ffuf", "feroxbuster", "nikto", "msfconsole",
        "aircrack-ng", "airodump-ng", "ncat", "responder", "bettercap", "wpscan",
        "dirb", "crackmapexec", "nuclei", "subfinder", "amass", "burpsuite",
        // Dev / IA
        "claude", "docker", "dockerd", "python3",
    ]

    /// Outils qui vont et viennent sans arrêt : on espace beaucoup leurs
    /// commentaires, sinon la chèvre parle en boucle.
    private let bavards: Set<String> = ["python3", "docker", "dockerd", "claude"]
    private let cooldownBavard: TimeInterval = 900

    func start() {
        let t = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.queue.async { self.scan() }
        }
        t.tolerance = 1
        timer = t
        queue.async { self.scan() }   // premier scan tout de suite (mémorise l'existant)
    }

    func stop() { timer?.invalidate(); timer = nil }

    private func scan() {
        guard let names = Self.currentProcessNames() else { return }

        // Premier scan : on mémorise sans réagir (sinon flood de tout ce qui
        // tourne déjà, dont le `claude` en cours).
        if firstScan {
            known = names
            firstScan = false
            return
        }

        let started = names.subtracting(known)
        let ended = known.subtracting(names)
        known = names

        for n in started where watch.contains(n) { fire(n, .started) }
        for n in ended where watch.contains(n) { fire(n, .ended) }
    }

    private func fire(_ name: String, _ event: Event) {
        let key = "\(name)#\(event)"
        let now = Date()
        let delai = bavards.contains(name) ? cooldownBavard : cooldown
        if let last = lastFired[key], now.timeIntervalSince(last) < delai { return }
        lastFired[key] = now
        DispatchQueue.main.async { [weak self] in self?.onEvent?(name, event) }
    }

    /// Ensemble des basenames de commande actuellement en cours.
    private static func currentProcessNames() -> Set<String>? {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/bin/ps")
        p.arguments = ["-axo", "comm="]
        let pipe = Pipe()
        p.standardOutput = pipe
        p.standardError = FileHandle.nullDevice
        do { try p.run() } catch { return nil }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        p.waitUntilExit()
        guard let s = String(data: data, encoding: .utf8) else { return nil }

        var set = Set<String>()
        for line in s.split(separator: "\n") {
            let comm = line.trimmingCharacters(in: .whitespaces)
            guard !comm.isEmpty else { continue }
            set.insert((comm as NSString).lastPathComponent.lowercased())
        }
        return set
    }
}
