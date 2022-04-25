// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "GIFImage",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0"),
        .tvOS("15.0"),
        .watchOS("8.0")
    ],
    products: [
        .library(
            name: "GIFImage",
            targets: ["GIFImage"]
        )
    ],
    targets: [
        .target(
            name: "GIFImage",
            path: "Sources"
        ),
        .testTarget(
            name: "GIFImageTests",
            dependencies: [
                "GIFImage"
            ],
            path: "Tests",
            resources: [
                .process("test.gif")
            ]
        )
    ]
)
