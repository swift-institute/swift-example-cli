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
        .package(url: "https://github.com/swift-institute/swift-example-signature.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-iso-9945-coder.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-9945.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Example CLI",
            dependencies: [
                .product(name: "Coder", package: "swift-coder"),
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Example Signature", package: "swift-example-signature"),
                .product(name: "Example Greeting Signature", package: "swift-example-signature"),
                .product(name: "Example Counter Signature", package: "swift-example-signature"),
                .product(name: "ISO 9945 Core", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Utility", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Utility Coder", package: "swift-iso-9945-coder"),
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
                "Example CLI",
                .product(name: "Example", package: "swift-example"),
                .product(name: "Example Greeting", package: "swift-example"),
                .product(name: "Example Counter", package: "swift-example"),
                .product(name: "Example Greeting Signature", package: "swift-example-signature"),
                .product(name: "Example Counter Signature", package: "swift-example-signature"),
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
