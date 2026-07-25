import SwiftUI

/// Rendu de la créature : une chèvre cyberpunk néon animée par sprites. La pose
/// affichée est pilotée par `PetController` (repos, marche, course, assis, dodo,
/// saut). On ajoute par-dessus un peu de mouvement procédural — respiration,
/// dandinement, retournement selon la direction — et une lueur au sol.
struct CreatureView: View {
    @ObservedObject var controller: PetController
    var onTap: () -> Void = {}

    private let cyan = Color(red: 0.16, green: 0.94, blue: 1.00)

    var body: some View {
        ZStack {
            // Lueur au sol, ancrée : elle ne suit pas la chèvre quand elle saute.
            // Volontairement subtile : trop marquée, elle créait un « blob » sombre
            // là où le corps (semi-transparent) passait au-dessus.
            Ellipse()
                .fill(cyan.opacity(controller.airborne ? 0.04 : 0.10))
                .frame(width: controller.airborne ? 40 : (controller.isWalking ? 64 : 76),
                       height: 11)
                .offset(y: 74)
                .blur(radius: 7)

            GoatSprites.image(controller.pose)
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: 176, height: 176)
                // AUCUNE animation SwiftUI implicite ici : tout le mouvement
                // (respiration, squash & stretch, dandinement) est piloté image
                // par image par la boucle 60 fps du controller. Une animation
                // `repeatForever` laisserait une transaction active en permanence,
                // qui capturerait le changement de sprite et ferait un fondu
                // enchaîné — d'où l'ancien fantôme superposé au nouveau.
                .scaleEffect(x: 1 / CGFloat(controller.squashY),
                             y: CGFloat(controller.squashY), anchor: .bottom)
                .rotationEffect(.degrees(controller.tilt), anchor: .bottom)
                // Art orienté à DROITE : on retourne quand la chèvre va à gauche.
                .scaleEffect(x: controller.facing == .left ? -1 : 1, y: 1)
        }
        .frame(width: 180, height: 180)
        // Geste sur le conteneur (hors flip/rotation) : un petit mouvement = tap
        // (poke), un vrai déplacement = on porte la chèvre.
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { controller.handleDragChanged($0.translation) }
                .onEnded { _ in
                    // Un vrai déplacement a eu lieu → on le termine proprement
                    // (réinitialise isDragging). Sinon c'était un simple tap.
                    if controller.isDragging { controller.handleDragEnded() }
                    else { onTap() }
                }
        )
    }
}
