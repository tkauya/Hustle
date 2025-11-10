// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HustleApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "HustleApp",
            targets: ["HustleApp"]
        )
    ],
    targets: [
        .target(
            name: "HustleApp",
            path: "Sources/HustleApp"
        )
    ]
)
