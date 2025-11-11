# Hustle

A SwiftUI sample project configured for the latest Xcode and iOS 17 SDK, ready for SwiftUI preview testing.

## Getting Started

1. Open the project folder in Xcode 15.4 or later (iOS 17 SDK or newer).
2. Choose **File ▸ Open** and select the `Package.swift` manifest.
3. Wait for Swift Package Manager to finish resolving the project.
4. Select the `AppModule` scheme and run the `Hustle` app on an iOS 17 simulator or device.

## SwiftUI Previews

`ContentView` ships with a `#Preview` configuration that renders in both light and dark appearances.
To ensure previews build correctly after updating to the latest Xcode/iOS SDK:

- The package manifest declares the `.iOSApplication` product, which Xcode converts into an app target automatically.
- The platform is pinned to **iOS 17**, matching the current SDK shipped with Xcode 16 / iOS 17 simulator images.
- The package relies solely on SwiftUI resources, so there are no binary assets to interfere with source-only workflows.

If Previews fail to load, choose **Product ▸ Clean Build Folder**, close the preview canvas, and reopen it.
