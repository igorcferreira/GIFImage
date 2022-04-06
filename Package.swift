// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "GIFImage"

let package = Package(
    name: packageName,
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15)
    ],
    products: [
        .library(
            name: packageName,
            targets: [packageName]),
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "\(packageName)Tests",
            dependencies: ["GIFImage"],
            resources: [
                .process("test.gif")
            ]
        )
    ]
)
