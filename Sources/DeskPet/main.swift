import AppKit

// Point d'entrée. Application « accessory » : pas d'icône dans le Dock,
// juste la créature qui flotte sur le bureau.
//
// Tout est exécuté sur l'acteur principal ; app.run() reste dans le bloc pour
// que `delegate` (référencé faiblement par NSApplication) reste en vie.
MainActor.assumeIsolated {
    let app = NSApplication.shared
    let delegate = AppDelegate()
    app.delegate = delegate
    app.setActivationPolicy(.accessory)
    app.run()
}
