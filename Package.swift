// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "DeskPet",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "DeskPet",
            path: "Sources/DeskPet",
            resources: [
                // Sprites néon de la chèvre (frames PNG transparents).
                .copy("Resources/goat")
            ],
            swiftSettings: [
                // Rester en mode langage Swift 5 pour éviter les frictions de
                // concurrence stricte de Swift 6 pendant le prototypage.
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
