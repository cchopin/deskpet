import SwiftUI
import AppKit

/// Les poses disponibles de la chèvre néon. La valeur brute correspond au nom
/// du fichier PNG dans Resources/goat/.
enum GoatPose: String, CaseIterable {
    case face
    case profilDroite = "profil_droite"
    case profilGauche = "profil_gauche"
    case troisQuarts  = "trois_quarts"
    case heureux
    case clinDoeil    = "clin_doeil"
    case reflechit
    case parle
    case assis
    case couche
    case marche1
    case marche2
    case course
    case saute
    case flotte
}

/// Charge une seule fois toutes les frames depuis le bundle et les garde en
/// mémoire. `Image(controller.pose)` reste alors instantané à chaque tick.
enum GoatSprites {
    private static let cache: [String: Image] = {
        var dict: [String: Image] = [:]
        for pose in GoatPose.allCases {
            if let url = Bundle.module.url(forResource: pose.rawValue,
                                           withExtension: "png",
                                           subdirectory: "goat"),
               let ns = NSImage(contentsOf: url) {
                dict[pose.rawValue] = Image(nsImage: ns)
            }
        }
        return dict
    }()

    static func image(_ pose: GoatPose) -> Image {
        cache[pose.rawValue] ?? Image(systemName: "questionmark.square.dashed")
    }
}
