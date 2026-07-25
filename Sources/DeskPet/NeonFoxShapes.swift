import SwiftUI

/// Tête du renard : dôme arrondi en haut, joues, menton pointu en bas.
struct FoxHead: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        var p = Path()
        let topL = CGPoint(x: w * 0.10, y: h * 0.30)
        let topR = CGPoint(x: w * 0.90, y: h * 0.30)
        let chin = CGPoint(x: w * 0.50, y: h * 0.98)

        p.move(to: topL)
        // Dôme du crâne.
        p.addQuadCurve(to: topR, control: CGPoint(x: w * 0.50, y: -h * 0.06))
        // Joue droite vers le menton.
        p.addQuadCurve(to: chin, control: CGPoint(x: w * 1.02, y: h * 0.62))
        // Joue gauche depuis le menton.
        p.addQuadCurve(to: topL, control: CGPoint(x: -w * 0.02, y: h * 0.62))
        p.closeSubpath()
        return p
    }
}

/// Une oreille triangulaire aux coins légèrement adoucis.
struct FoxEar: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        var p = Path()
        p.move(to: CGPoint(x: w * 0.05, y: h))          // base gauche
        p.addQuadCurve(to: CGPoint(x: w * 0.55, y: 0),  // pointe
                       control: CGPoint(x: w * 0.10, y: h * 0.25))
        p.addQuadCurve(to: CGPoint(x: w * 0.95, y: h),  // base droite
                       control: CGPoint(x: w * 0.95, y: h * 0.35))
        p.closeSubpath()
        return p
    }
}

/// Œil en amande, incliné façon renard.
struct FoxEye: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        var p = Path()
        p.move(to: CGPoint(x: 0, y: h * 0.5))
        p.addQuadCurve(to: CGPoint(x: w, y: h * 0.5),
                       control: CGPoint(x: w * 0.5, y: 0))
        p.addQuadCurve(to: CGPoint(x: 0, y: h * 0.5),
                       control: CGPoint(x: w * 0.5, y: h))
        p.closeSubpath()
        return p
    }
}

/// Truffe : petit triangle inversé.
struct FoxNose: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: w, y: 0))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h),
                       control: CGPoint(x: w * 0.5, y: h * 0.7))
        p.closeSubpath()
        return p
    }
}

/// Queue touffue : un gros panache large, attaché à la hanche, sweepant en haut
/// à gauche avec une pointe arrondie.
struct FoxTail: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width, h = rect.height
        var p = Path()
        let baseBottom = CGPoint(x: w * 0.80, y: h * 0.98)
        let tip = CGPoint(x: w * 0.16, y: h * 0.22)
        let baseTop = CGPoint(x: w * 0.98, y: h * 0.58)
        p.move(to: baseBottom)
        // Bord extérieur (dessous) : large ventre qui balaie vers le bas-gauche.
        p.addQuadCurve(to: tip, control: CGPoint(x: w * 0.16, y: h * 0.98))
        // Bord intérieur (dessus) : contrôle haut → grosse épaisseur.
        p.addQuadCurve(to: baseTop, control: CGPoint(x: w * 0.66, y: h * 0.04))
        p.closeSubpath()
        return p
    }
}

extension View {
    /// Halo néon : deux ombres colorées empilées pour un effet de bloom.
    func neonGlow(_ color: Color, radius: CGFloat = 5) -> some View {
        self
            .shadow(color: color.opacity(0.9), radius: radius)
            .shadow(color: color.opacity(0.55), radius: radius * 2.2)
    }
}
