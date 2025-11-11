// swift-tools-version: 6.1
import PackageDescription

#if os(Linux)
let package = Package(
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
#else
let package = Package(
    name: "Hustle",
    platforms: [
        .iOS(.v17)
    ],
    products: [
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
#endif
