import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: PetWindow?
    private let controller = PetController()
    private let brain = PetBrain()
    private var watcher: DesktopWatcher?
    private var procWatcher: ProcessWatcher?
    private var appTimer: Timer?
    private var lifeTimer: Timer?
    private var lastAppName: String?

    // Fenêtre volontairement haute : la chèvre occupe le bas, la bulle a de la
    // marge en haut pour ne jamais être rognée.
    static let petSize = NSSize(width: 260, height: 330)

    func applicationDidFinishLaunching(_ notification: Notification) {
        let size = AppDelegate.petSize

        let window = PetWindow(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]
        // Le déplacement est géré par un geste sur la chèvre (voir CreatureView),
        // pas par le déplacement natif de fenêtre qui se battrait avec le contrôleur.
        window.isMovableByWindowBackground = false

        let root = PetRootView(controller: controller, brain: brain)
        let hosting = NSHostingView(rootView: root)
        hosting.frame = NSRect(origin: .zero, size: size)
        window.contentView = hosting

        if let screen = NSScreen.main {
            let vf = screen.visibleFrame
            window.setFrameOrigin(NSPoint(x: vf.maxX - size.width - 30,
                                          y: vf.minY + 30))
        }

        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        self.window = window

        controller.window = window
        controller.start()

        startObserving()

        // Mot de retour si l'humain revient après une absence (laisse la fenêtre
        // s'installer d'abord).
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            MainActor.assumeIsolated { self?.brain.welcomeBack() }
        }
    }

    // MARK: - Observateur de bureau

    private func startObserving() {
        // Niveaux 1 & 2 : nouveaux fichiers / screenshots.
        let watcher = DesktopWatcher()
        watcher.onNewFile = { [weak self] url in
            MainActor.assumeIsolated { self?.brain.reactToFile(url) }
        }
        watcher.start()
        self.watcher = watcher

        // Niveau 4 : lancement / arrêt d'outils (sécu, dev).
        let procWatcher = ProcessWatcher()
        procWatcher.onEvent = { [weak self] tool, event in
            MainActor.assumeIsolated {
                self?.brain.reactToProcess(tool, started: event == .started)
            }
        }
        procWatcher.start()
        self.procWatcher = procWatcher

        // Niveau 3 bis : lancement / fermeture d'applications GUI (Discord, etc.).
        let wsnc = NSWorkspace.shared.notificationCenter
        wsnc.addObserver(forName: NSWorkspace.didLaunchApplicationNotification,
                         object: nil, queue: .main) { [weak self] note in
            MainActor.assumeIsolated { self?.handleAppLifecycle(note, launched: true) }
        }
        wsnc.addObserver(forName: NSWorkspace.didTerminateApplicationNotification,
                         object: nil, queue: .main) { [weak self] note in
            MainActor.assumeIsolated { self?.handleAppLifecycle(note, launched: false) }
        }

        // Niveau 3 : commentaire occasionnel sur l'app au premier plan.
        appTimer = Timer.scheduledTimer(withTimeInterval: 150, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.commentOnFrontApp() }
        }

        // Battement de vie : fait dériver l'humeur et lâche parfois une remarque
        // spontanée (ennui, fatigue...).
        lifeTimer = Timer.scheduledTimer(withTimeInterval: 90, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.brain.lifeTick() }
        }
    }

    private func handleAppLifecycle(_ note: Notification, launched: Bool) {
        guard let app = note.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              app.activationPolicy == .regular,          // vraies apps, pas les agents
              let name = app.localizedName,
              !name.contains("DeskPet") else { return }
        brain.reactToAppLifecycle(name, launched: launched)
    }

    private func commentOnFrontApp() {
        guard Double.random(in: 0...1) < 0.4 else { return }
        guard let app = NSWorkspace.shared.frontmostApplication,
              let name = app.localizedName else { return }
        // On évite de commenter notre propre process ou un changement identique.
        if name.contains("DeskPet") || name == lastAppName { return }
        lastAppName = name
        brain.reactToApp(name)
    }
}
