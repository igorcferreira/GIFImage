// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JIFView",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "JIFView",
            targets: ["JIFView"]),
    ],
    targets: [
        .target(
            name: "JIFView",
            path: "Sources"),
        .testTarget(
            name: "JIFViewTests",
            dependencies: ["JIFView"],
            path: "Tests")
    ],
    swiftLanguageVersions: [.v5]
)
