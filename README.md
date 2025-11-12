# Hustle

Hustle is a SwiftUI coaching companion that helps you plan, track, and celebrate focused work sessions while staying compatible with the latest stable iOS SDK bundled with Xcode. The project ships as a Swift Package so you can inspect it from Linux tooling yet still open it directly in Xcode for previews.

## Requirements

- Xcode 15.4 or newer (provides the iOS 17 SDK and Swift 5.9 toolchain)
- iOS 17 simulator or device when running the application target
- macOS 13 or newer for SwiftUI previews

> **Why not iOS 18/26?**
> The manifest targets the publicly released SDK so Intel and Apple Silicon Macs can build without experimental downloads. You get reliable previews on macOS while still producing a full iOS application product.

## Opening the project in Xcode

1. Launch Xcode and choose **File ▸ Open…**.
2. Select the `Package.swift` manifest from the repository root.
3. Pick the **Hustle** scheme after the package resolves.
4. Choose an iOS 17 simulator (for example, iPhone 15) and press **⌘R** to run.

Xcode automatically synthesises an iOS application target on Apple platforms thanks to the conditional `.iOSApplication` product in the manifest. On Linux and other environments the target behaves as a simple executable so command-line tooling remains happy.

## Feature overview

The SwiftUI interface is composed of modular views backed by an observable `FocusSessionViewModel`:

- **Session header** – Shows the active focus area, radial progress indicator, streak information, and actionable insights.
- **Controls** – Configure the session goal, focus context, and toggle rest mode. The primary action button adapts between start, pause, resume, and restart states.
- **Milestones** – Auto-classified checkpoints that progress from upcoming → in progress → completed based on elapsed minutes.
- **Notes** – A lightweight text journal for capturing takeaways without leaving the dashboard.
- **Celebrations** – When you hit the configured goal a banner slides in so previews and devices both surface the accomplishment.

Because gradients, icons, and copy are all generated in SwiftUI code, the repository stays source-only with no binary assets. This keeps previews deterministic and works nicely with cloud CI.

## SwiftUI previews

The dashboard uses a dedicated view model that isolates timer state, so previews stay responsive even while the timeline updates. If the preview canvas stalls, clean the derived data (**Product ▸ Clean Build Folder**) and refresh with **⌘⌥P**.

## Command-line behaviour

On hosts that cannot import SwiftUI (such as Linux containers) the executable prints a friendly message explaining that the graphical experience requires macOS or iOS. This allows automation workflows to succeed without rendering the UI.

## Repository layout

```
Hustle/
├── Package.swift
├── README.md
└── Sources/
    └── AppModule/
        ├── ContentView.swift           # SwiftUI dashboard and supporting components
        ├── FocusSessionViewModel.swift # Observable view model and support types
        ├── HustleApp.swift             # Entry point with CLI fallback
        └── Resources/
            └── Assets.xcassets
                └── Contents.json
```

Feel free to evolve the milestones, copy, or styling to match your brand. The modular structure makes it easy to extend with additional views or unit tests.
