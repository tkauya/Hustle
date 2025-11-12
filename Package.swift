// swift-tools-version: 5.9
import PackageDescription
import Foundation

var package = Package(
    name: "Hustle",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .executable(name: "Hustle", targets: ["AppModule"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources/AppModule",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .unsafeFlags(["-warnings-as-errors"], .when(configuration: .debug))
            ]
        )
    ]
)

#if canImport(UIKit)
package.products.append(
    .iOSApplication(
        name: "Hustle",
        targets: ["AppModule"],
        bundleIdentifier: "com.example.hustle",
        teamIdentifier: nil,
        displayVersion: "1.0",
        bundleVersion: "1",
        accentColor: .presetColor(.orange),
        supportedDeviceFamilies: [
            .phone,
            .pad
        ],
        supportedInterfaceOrientations: [
            .portrait,
            .portraitUpsideDown,
            .landscapeLeft,
            .landscapeRight
        ],
        supportedInterfaceOrientationsPad: [
            .portrait,
            .portraitUpsideDown,
            .landscapeLeft,
            .landscapeRight
        ]
    )
)
#endif
