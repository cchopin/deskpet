import AppKit
import SwiftUI

enum Facing {
    case left, right
}

/// Pilote le déplacement de la fenêtre sur le bureau ET l'animation par frames
/// de la chèvre. Une boucle 60 fps unique fait tourner une petite machine à
/// états (repos, marche, course, assis, dodo, saut) et publie à chaque tick la
/// `pose` à afficher, la direction et l'inclinaison du corps.
///
/// Sens canonique de l'art : la chèvre regarde à DROITE. On la retourne
/// horizontalement quand elle se dirige à gauche.
final class PetController: ObservableObject {
    @Published var facing: Facing = .left
    @Published var pose: GoatPose = .face
    /// Léger dandinement en degrés pendant la marche.
    @Published var tilt: Double = 0
    /// Étirement vertical (squash & stretch). 1 = neutre, >1 étiré, <1 écrasé.
    /// La vue applique l'inverse en horizontal (conservation du volume).
    @Published var squashY: Double = 1

    weak var window: NSWindow?

    var isWalking: Bool { activity == .walking || activity == .running }
    /// La lueur au sol disparaît quand la chèvre est en l'air.
    var airborne: Bool { pose == .saute || pose == .course || pose == .flotte }

    private enum Activity { case idle, walking, running, sitting, sleeping, jumping }
    private var activity: Activity = .idle

    // Déplacement manuel par l'utilisateur (glisser la chèvre).
    private(set) var isDragging = false
    private var dragOrigin: CGPoint?

    private var timer: Timer?
    private let tick: TimeInterval = 1.0 / 60.0
    private let walkSpeed: CGFloat = 72       // px/s
    private let runSpeed: CGFloat  = 210      // px/s

    // Ancre de repos (position stable de la fenêtre).
    private var restX: CGFloat = 0
    private var restY: CGFloat = 0

    // Repos.
    private var idlePhase: Double = 0
    private var idleRemaining: TimeInterval = 0
    // Petites émotions ponctuelles au repos (clin d'œil, sourire, réflexion).
    private var emoteRemaining: TimeInterval = 0
    private var emotePose: GoatPose = .face
    private var nextEmoteIn: TimeInterval = 0

    // Assis / dodo.
    private var stateRemaining: TimeInterval = 0

    // Balade.
    private var startX: CGFloat = 0
    private var startY: CGFloat = 0
    private var distX: CGFloat = 0
    private var distY: CGFloat = 0
    private var duration: TimeInterval = 1
    private var elapsed: TimeInterval = 0

    // Saut (arc vertical de la fenêtre).
    private var jumpElapsed: TimeInterval = 0
    private var jumpDuration: TimeInterval = 0.72
    private var jumpHeight: CGFloat = 52

    func start() {
        guard let window else { return }
        restX = window.frame.origin.x
        restY = window.frame.origin.y
        enterIdle(duration: Double.random(in: 2...4))
        timer = Timer.scheduledTimer(withTimeInterval: tick, repeats: true) { [weak self] _ in
            self?.update()
        }
    }

    // MARK: - Boucle principale

    private func update() {
        guard let window else { return }
        guard !isDragging else { return }   // l'utilisateur la déplace : on ne touche à rien
        switch activity {
        case .idle:      updateIdle(window)
        case .sitting:   updateResting(window, restPose: .assis)
        case .sleeping:  updateResting(window, restPose: .couche)
        case .walking, .running: updateTravel(window)
        case .jumping:   updateJump(window)
        }
    }

    // MARK: - Repos debout

    private func updateIdle(_ window: NSWindow) {
        idlePhase += tick
        idleRemaining -= tick

        // Flottement lent.
        let float = CGFloat(sin(idlePhase * 1.6) * 3)
        window.setFrameOrigin(NSPoint(x: restX, y: restY + float))

        // Gestion des émotions ponctuelles.
        if emoteRemaining > 0 {
            emoteRemaining -= tick
            pose = emoteRemaining > 0 ? emotePose : .face
        } else {
            nextEmoteIn -= tick
            if nextEmoteIn <= 0 { triggerIdleEmote() }
        }

        if idleRemaining <= 0 { chooseNextIdleBehavior() }
    }

    private func triggerIdleEmote() {
        // Un petit répertoire d'expressions au repos.
        switch Int.random(in: 0...3) {
        case 0: emotePose = .clinDoeil; emoteRemaining = 0.5
        case 1: emotePose = .heureux;   emoteRemaining = 1.1
        case 2: emotePose = .reflechit; emoteRemaining = 1.3
        default: emotePose = .clinDoeil; emoteRemaining = 0.45
        }
        pose = emotePose
        nextEmoteIn = Double.random(in: 3.5...7.0)
    }

    /// À la fin d'une plage de repos, on choisit la suite : rester debout,
    /// s'asseoir, dormir, ou partir se balader.
    private func chooseNextIdleBehavior() {
        switch Int.random(in: 0..<100) {
        case 0..<45:  beginWander()                       // se balade
        case 45..<70: enterIdle(duration: Double.random(in: 3...6))
        case 70..<90: enterRest(.sitting, Double.random(in: 5...12))
        default:      enterRest(.sleeping, Double.random(in: 8...20))
        }
    }

    private func enterIdle(duration: TimeInterval) {
        activity = .idle
        pose = .face
        tilt = 0
        squashY = 1
        idlePhase = 0
        idleRemaining = duration
        emoteRemaining = 0
        nextEmoteIn = Double.random(in: 2.5...5.0)
    }

    // MARK: - Assis / dodo

    private func enterRest(_ act: Activity, _ dur: TimeInterval) {
        activity = act
        pose = (act == .sleeping) ? .couche : .assis
        tilt = 0
        squashY = 1
        stateRemaining = dur
        // Se pose bien au sol (annule le flottement résiduel).
        window.map { $0.setFrameOrigin(NSPoint(x: restX, y: restY)) }
    }

    private func updateResting(_ window: NSWindow, restPose: GoatPose) {
        stateRemaining -= tick
        // Respiration très légère pour le dodo (haut/bas imperceptible).
        if restPose == .couche {
            let breathe = CGFloat(sin(idlePhase * 1.1) * 1.2)
            idlePhase += tick
            window.setFrameOrigin(NSPoint(x: restX, y: restY + breathe))
        }
        if stateRemaining <= 0 {
            // « Se lève » : petite pause debout avant de reprendre.
            enterIdle(duration: Double.random(in: 1.5...3.0))
        }
    }

    // MARK: - Balade (marche / course)

    private func beginWander() {
        guard let window, let screen = window.screen ?? NSScreen.main else {
            enterIdle(duration: Double.random(in: 2...4)); return
        }
        let vf = screen.visibleFrame
        let size = window.frame.size
        let minX = vf.minX + 20, maxX = vf.maxX - size.width - 20
        let minY = vf.minY + 20, maxY = vf.maxY - size.height - 20
        guard maxX > minX, maxY > minY else {
            enterIdle(duration: Double.random(in: 2...4)); return
        }

        let targetX = min(max(restX + CGFloat.random(in: -420...420), minX), maxX)
        let targetY = min(max(restY + CGFloat.random(in: -260...260), minY), maxY)

        startX = restX; startY = restY
        distX = targetX - startX; distY = targetY - startY

        let dist = hypot(distX, distY)
        guard dist > 16 else { enterIdle(duration: Double.random(in: 2...5)); return }

        // Au-delà d'une certaine distance, la chèvre se met à courir.
        let run = dist > 300
        activity = run ? .running : .walking
        duration = max(0.5, TimeInterval(dist / (run ? runSpeed : walkSpeed)))
        elapsed = 0
        facing = distX >= 0 ? .right : .left
    }

    private func updateTravel(_ window: NSWindow) {
        elapsed += tick
        let t = min(1, elapsed / duration)
        let eased = t * t * (3 - 2 * t)          // smoothstep accel/décel
        let damp = sin(.pi * t)                  // 0 aux extrémités, 1 au milieu

        let running = (activity == .running)
        let x = startX + distX * CGFloat(eased)

        // Rebond vertical : plus ample et rapide en course.
        let bobFreq: Double = running ? 13 : 9.5
        let bobAmp: CGFloat = running ? 7 : 4
        let bobSrc = sin(elapsed * bobFreq)
        let y = startY + distY * CGFloat(eased) + CGFloat(abs(bobSrc)) * bobAmp * CGFloat(damp)
        tilt = bobSrc * (running ? 3 : 5) * damp
        squashY = 1 + 0.045 * bobSrc * damp        // légère respiration verticale du pas
        window.setFrameOrigin(NSPoint(x: x, y: y))

        // Sélection de frame : course = une pose dynamique ; marche = cycle 2 frames.
        if running {
            pose = .course
        } else {
            pose = (Int(elapsed / 0.16) % 2 == 0) ? .marche1 : .marche2
        }

        if t >= 1 {
            restX = startX + distX
            restY = startY + distY
            window.setFrameOrigin(NSPoint(x: restX, y: restY))
            tilt = 0
            enterIdle(duration: Double.random(in: 2.5...6))
        }
    }

    // MARK: - Saut (déclenché par un clic)

    /// Appelé quand l'humain tapote la chèvre : petit saut de surprise.
    func poked() {
        // On n'interrompt pas une balade en cours (ça saccaderait).
        guard activity == .idle || activity == .sitting || activity == .sleeping else { return }
        activity = .jumping
        jumpElapsed = 0
        pose = .saute
        tilt = 0
    }

    private func updateJump(_ window: NSWindow) {
        jumpElapsed += tick
        let t = jumpElapsed / jumpDuration

        if t < 0.16 {
            // Anticipation : elle s'accroupit au sol avant de bondir.
            let k = t / 0.16
            squashY = 1 - 0.20 * sin(k * .pi / 2)     // descend vers ~0.80
            pose = .heureux
            window.setFrameOrigin(NSPoint(x: restX, y: restY))
        } else if t < 0.9 {
            // Vol : arc + étirement à la montée, compression à la descente.
            let ft = (t - 0.16) / 0.74
            let arc = sin(.pi * ft)
            squashY = 1 + 0.16 * cos(.pi * ft)         // étiré au décollage → écrasé en bas
            pose = .saute
            window.setFrameOrigin(NSPoint(x: restX, y: restY + jumpHeight * CGFloat(arc)))
        } else if t < 1 {
            // Impact : écrasement puis retour au neutre.
            let k = (t - 0.9) / 0.1
            squashY = 0.80 + 0.20 * k
            pose = .heureux
            window.setFrameOrigin(NSPoint(x: restX, y: restY))
        } else {
            squashY = 1
            window.setFrameOrigin(NSPoint(x: restX, y: restY))
            enterIdle(duration: Double.random(in: 2...4))
        }
    }

    // MARK: - Déplacement manuel (glisser la chèvre)

    /// Appelé pendant que l'utilisateur fait glisser la chèvre. `translation`
    /// est le déplacement cumulé depuis le début du geste (repère SwiftUI, y bas).
    func handleDragChanged(_ translation: CGSize) {
        guard let window else { return }
        if dragOrigin == nil {
            dragOrigin = window.frame.origin
            isDragging = true
            pose = .heureux            // elle apprécie qu'on la porte
            tilt = 0
        }
        let o = dragOrigin!
        // y inversé : SwiftUI descend, AppKit monte.
        window.setFrameOrigin(NSPoint(x: o.x + translation.width,
                                      y: o.y - translation.height))
    }

    /// Fin du glisser : la position courante devient la nouvelle ancre de repos.
    func handleDragEnded() {
        if let window {
            restX = window.frame.origin.x
            restY = window.frame.origin.y
        }
        dragOrigin = nil
        isDragging = false
        enterIdle(duration: Double.random(in: 2...4))
    }
}
