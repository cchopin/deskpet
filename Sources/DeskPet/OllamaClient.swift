import Foundation
import AppKit

/// Petit client pour l'API locale d'Ollama (http://localhost:11434).
struct OllamaClient {
    var base = URL(string: "http://localhost:11434")!

    enum Model {
        static let text = "qwen2.5:14b"   // FR soigné, vannes contextuelles (64 Go RAM)
        static let vision = "moondream"
    }

    /// Génère une réponse texte (avec éventuellement des images en base64 pour
    /// les modèles de vision).
    func generate(model: String,
                  prompt: String,
                  system: String? = nil,
                  images: [String]? = nil,
                  temperature: Double = 0.5,
                  numPredict: Int = 60) async -> String? {
        var req = URLRequest(url: base.appendingPathComponent("/api/generate"))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.timeoutInterval = 60

        var body: [String: Any] = [
            "model": model,
            "prompt": prompt,
            "stream": false,
            "options": ["temperature": temperature, "num_predict": numPredict]
        ]
        if let system { body["system"] = system }
        if let images { body["images"] = images }

        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else { return nil }
            let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let text = (obj?["response"] as? String)?
                .trimmingCharacters(in: .whitespacesAndNewlines)
            return (text?.isEmpty ?? true) ? nil : text
        } catch {
            return nil
        }
    }
}

enum ImageUtil {
    /// Charge une image, la réduit (côté max) et renvoie du JPEG encodé base64
    /// pour l'envoyer à un modèle de vision sans exploser la taille.
    static func base64DownscaledJPEG(url: URL, maxSide: CGFloat = 1024) -> String? {
        guard let image = NSImage(contentsOf: url),
              let tiff = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff) else { return nil }

        let w = CGFloat(rep.pixelsWide), h = CGFloat(rep.pixelsHigh)
        guard w > 0, h > 0 else { return nil }
        let scale = min(1, maxSide / max(w, h))
        let targetSize = NSSize(width: w * scale, height: h * scale)

        let resized = NSImage(size: targetSize)
        resized.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: targetSize))
        resized.unlockFocus()

        guard let rtiff = resized.tiffRepresentation,
              let rrep = NSBitmapImageRep(data: rtiff),
              let jpeg = rrep.representation(using: .jpeg, properties: [.compressionFactor: 0.7])
        else { return nil }
        return jpeg.base64EncodedString()
    }
}
