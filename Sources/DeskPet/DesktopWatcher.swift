import Foundation

/// Surveille des dossiers (par défaut Bureau + Téléchargements) et signale
/// l'apparition d'un nouveau fichier. Simple polling, robuste et sans permission
/// particulière au-delà de l'accès aux dossiers (macOS demandera l'autorisation
/// une fois).
final class DesktopWatcher {
    private let folders: [URL]
    private let interval: TimeInterval
    private var known = Set<String>()
    private var timer: Timer?

    /// Appelé sur le thread principal avec l'URL du nouveau fichier.
    var onNewFile: ((URL) -> Void)?

    private let ignoredNames: Set<String> = [".DS_Store", ".localized"]
    private let ignoredExtensions: Set<String> = ["download", "crdownload", "part", "tmp"]

    init(interval: TimeInterval = 4) {
        let home = FileManager.default.homeDirectoryForCurrentUser
        self.folders = [
            home.appendingPathComponent("Desktop"),
            home.appendingPathComponent("Downloads")
        ]
        self.interval = interval
    }

    func start() {
        // On enregistre l'existant pour ne pas réagir à ce qui est déjà là.
        known = currentFiles()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.scan()
        }
    }

    private func currentFiles() -> Set<String> {
        var set = Set<String>()
        let fm = FileManager.default
        for folder in folders {
            guard let items = try? fm.contentsOfDirectory(
                at: folder,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            ) else { continue }
            for url in items where isEligible(url) {
                set.insert(url.path)
            }
        }
        return set
    }

    private func isEligible(_ url: URL) -> Bool {
        let name = url.lastPathComponent
        if ignoredNames.contains(name) { return false }
        if ignoredExtensions.contains(url.pathExtension.lowercased()) { return false }
        return true
    }

    private func scan() {
        let now = currentFiles()
        let fresh = now.subtracting(known)
        known = now
        guard let newest = fresh.first else { return }
        // Un seul par tour pour éviter le spam si plusieurs fichiers arrivent.
        onNewFile?(URL(fileURLWithPath: newest))
    }
}
