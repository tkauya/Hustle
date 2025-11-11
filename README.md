# Hustle

A SwiftUI sample project configured for the latest Xcode and iOS 17 SDK, ready for SwiftUI preview testing without requiring unreleased simulator runtimes.

## Getting Started

1. Open the project folder in Xcode 15.4 or later (ships with the stable iOS 17 SDK).
2. Choose **File ▸ Open** and select the `Package.swift` manifest. Xcode 15.x understands the Swift 5.9 tools version used by this package, so it builds cleanly on macOS without additional downloads.
3. Wait for Swift Package Manager to finish resolving the project.
4. Select the `AppModule` scheme and run the `Hustle` app on an iOS 17 simulator or device.

## SwiftUI Previews

`ContentView` ships with a `#Preview` configuration that renders in both light and dark appearances.
To ensure previews build correctly after updating to the latest Xcode/iOS SDK:

- The package manifest declares the `.iOSApplication` product, which Xcode converts into an app target automatically.
- The platform is pinned to **iOS 17**, matching the stable SDK shipped with current Xcode releases while avoiding the experimental iOS 18/Swift 6 toolchains.
- The package relies solely on SwiftUI resources, so there are no binary assets to interfere with source-only workflows.

If Previews fail to load, choose **Product ▸ Clean Build Folder**, close the preview canvas, and reopen it.
