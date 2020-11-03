// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName = "GIFImage"

let package = Package(
    name: packageName,
    platforms: [
        .macOS(.v11), .iOS(.v13), .tvOS(.v13)
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
        )
    ]
)
