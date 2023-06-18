// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-networkable",
    platforms: [
        .macOS(.v12),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "Networkable",
            targets: ["Networkable"]
        ),
        .executable(
            name: "NetworkableClient",
            targets: ["NetworkableClient"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"
        ),
        .package(
            url: "https://github.com/realm/SwiftLint",
            from: "0.52.2"
        ),
    ],
    targets: [
        .macro(
            name: "NetworkableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "Networkable",
            dependencies: ["NetworkableMacros"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .executableTarget(name: "NetworkableClient", dependencies: ["Networkable"]),
        .testTarget(
            name: "NetworkableTests",
            dependencies: [
                "NetworkableMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
