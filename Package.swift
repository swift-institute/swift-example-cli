// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-example-cli",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Example CLI",
            targets: ["Example CLI"]
        ),
        .executable(
            name: "example-cli",
            targets: ["example-cli"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-coder.git", branch: "main"),
        .package(url: "https://github.com/swift-institute/swift-example.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-9945.git", branch: "main", traits: ["Coder"]),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-optic.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-operation.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Example CLI",
            dependencies: [
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Example", package: "swift-example"),
                .product(name: "ISO 9945 Core", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Utility", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Utility Coder", package: "swift-iso-9945"),
                .product(name: "Optic", package: "swift-optic"),
                .product(name: "Operation", package: "swift-operation"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .executableTarget(
            name: "example-cli",
            dependencies: [
                .product(name: "Example", package: "swift-example"),
                "Example CLI",
            ]
        ),
        .testTarget(
            name: "Example CLI Tests",
            dependencies: [
                .product(name: "Operation", package: "swift-operation"),
                "Example CLI",
                .product(name: "Example", package: "swift-example"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
