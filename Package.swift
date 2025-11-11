// swift-tools-version: 5.9
import PackageDescription

var package = Package(
    name: "Hustle",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "Hustle", targets: ["AppModule"])
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources/AppModule",
            resources: [
                .process("Resources")
            ]
        )
    ]
)

#if !os(Linux)
package.products.append(
    .iOSApplication(
        name: "Hustle",
        targets: ["AppModule"],
        bundleIdentifier: "com.example.hustle",
        teamIdentifier: "ABCDE12345",
        displayVersion: "1.0",
        bundleVersion: "1",
        accentColor: .presetColor(.pink),
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
