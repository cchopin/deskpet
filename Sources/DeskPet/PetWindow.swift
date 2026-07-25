import AppKit

/// Fenêtre sans bordure et transparente qui héberge la créature.
/// Un NSWindow borderless ne peut pas devenir « key » par défaut ; on l'autorise
/// pour pouvoir capter les clics quand on ajoutera l'interaction.
final class PetWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
