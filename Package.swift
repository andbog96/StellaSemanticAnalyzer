// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StellaSemanticAnalyzer",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/davedufresne/SwiftParsec.git", from: "4.0.1"),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.6.0"))
    ],
    targets: [
        .executableTarget(
            name: "StellaSemanticAnalyzer",
            dependencies: [
                .product(name: "SwiftParsec", package: "SwiftParsec"),
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "StellaSemanticAnalyzerTests",
            dependencies: [.target(name: "StellaSemanticAnalyzer")]
        )
    ]
)
