import SwiftUI

/// Bulle de dialogue au-dessus du renard. Fond sombre translucide, liseré cyan
/// néon, petite pointe vers le bas. Affiche un texte, ou trois points animés
/// quand la créature « réfléchit ».
struct SpeechBubble: View {
    let text: String?
    let thinking: Bool

    private let cyan = Color(red: 0.16, green: 0.94, blue: 1.00)

    var body: some View {
        Group {
            if thinking {
                ThinkingDots(color: cyan)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(bubbleBackground)
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
            } else if let text, !text.isEmpty {
                Text(text)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)                       // garde-fou anti-débordement
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: 210)
                    .background(bubbleBackground)
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
    }

    private var bubbleBackground: some View {
        BubbleShape()
            .fill(Color.black.opacity(0.82))
            .overlay(
                BubbleShape().stroke(cyan.opacity(0.75), lineWidth: 1.5)
                    .shadow(color: cyan.opacity(0.7), radius: 4)
                    .shadow(color: cyan.opacity(0.4), radius: 8)
            )
    }
}

/// Rectangle arrondi avec une petite pointe centrée en bas.
struct BubbleShape: Shape {
    var corner: CGFloat = 12
    var tail: CGFloat = 8

    func path(in rect: CGRect) -> Path {
        let body = CGRect(x: rect.minX, y: rect.minY,
                          width: rect.width, height: rect.height - tail)
        var p = Path(roundedRect: body, cornerRadius: corner)
        // Pointe vers le bas.
        var tri = Path()
        tri.move(to: CGPoint(x: rect.midX - tail, y: body.maxY - 1))
        tri.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        tri.addLine(to: CGPoint(x: rect.midX + tail, y: body.maxY - 1))
        tri.closeSubpath()
        p.addPath(tri)
        return p
    }
}

struct ThinkingDots: View {
    let color: Color
    @State private var phase = 0

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(color)
                    .frame(width: 5, height: 5)
                    .opacity(phase == i ? 1 : 0.3)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                phase = (phase + 1) % 3
            }
        }
    }
}
