// swift-tools-version: 5.6

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Sample",
    platforms: [
        .macOS("12.0"),
        .iOS("15.0"),
        .tvOS("15.0"),
        .watchOS("8.0")
    ],
    products: [
        .iOSApplication(
            name: "Sample",
            targets: ["Sample"],
            bundleIdentifier: "com.igorcferreira.gifimage.sample",
            teamIdentifier: "V5F865B4U5",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .images),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .pad,
                .phone,
                .mac,
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeLeft,
                .landscapeRight,
                .portraitUpsideDown(.when(deviceFamilies: [.pad, .mac]))
            ],
            appCategory: .developerTools
        ),
        .library(
            name: "GIFImage",
            targets: ["GIFImage"]
        )
    ],
    targets: [
        .executableTarget(
            name: "Sample",
            dependencies: [
                "GIFImage"
            ],
            path: "Sample"
        ),
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
