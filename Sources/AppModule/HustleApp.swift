#if canImport(SwiftUI)
import SwiftUI

@main
struct HustleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
#else
@main
struct HustleCLI {
    static func main() {
        print("Hustle runs as a SwiftUI experience. Launch it from macOS or iOS to view the dashboard.")
    }
}
#endif
