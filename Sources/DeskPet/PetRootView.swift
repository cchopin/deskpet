import SwiftUI

/// Vue racine hébergée dans la fenêtre : la bulle de dialogue au-dessus, le
/// renard en dessous. La zone de la bulle est réservée pour que le renard ne
/// saute pas quand il parle.
struct PetRootView: View {
    @ObservedObject var controller: PetController
    @ObservedObject var brain: PetBrain

    var body: some View {
        VStack(spacing: 2) {
            SpeechBubble(text: brain.speech, thinking: brain.thinking)
                .frame(width: 250, height: 140, alignment: .bottom)

            CreatureView(controller: controller) {
                controller.poked()   // petit saut de surprise
                brain.poke()         // + réplique
            }
            .frame(width: 180, height: 180)
        }
        .frame(width: 260, height: 330)
    }
}
