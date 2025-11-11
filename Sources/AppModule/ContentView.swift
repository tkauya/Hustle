import SwiftUI
import Foundation

struct ContentView: View {
    @State private var hustleCount: Int
    @State private var isResting: Bool

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(initialHustleCount: Int = 0, initialIsResting: Bool = false) {
        _hustleCount = State(initialValue: Self.clamped(initialHustleCount))
        _isResting = State(initialValue: initialIsResting)
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Hustle Meter")
                .font(.largeTitle.weight(.bold))

            ProgressView(value: Double(hustleCount), total: 60)
                .progressViewStyle(.linear)
                .tint(isResting ? .mint : .orange)
                .animation(.easeInOut(duration: 0.3), value: hustleCount)

            Text(hustleStatus)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .transition(.opacity.combined(with: .scale))

            Toggle(isOn: $isResting.animation()) {
                Label("Recovery Mode", systemImage: "powersleep")
            }
            .toggleStyle(.switch)

            Button(action: resetMeter) {
                Label("Reset Counter", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.thinMaterial, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(32)
        .frame(maxWidth: 360)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .padding()
        .background(BackgroundGradient())
        .onReceive(timer) { _ in
            updateMeter()
        }
        .animation(.spring(duration: 0.45), value: isResting)
    }

    private var hustleStatus: String {
        switch hustleCount {
        case 0:
            return "Tap reset to begin your hustle session."
        case 1..<20:
            return "You're warming up. Keep the momentum!"
        case 20..<40:
            return "Great pace! Stay focused and hydrated."
        case 40..<60:
            return "Elite hustle! Consider toggling Recovery Mode for balance."
        default:
            return "You've maxed out today's hustle—time to celebrate!"
        }
    }

    private func updateMeter() {
        guard !isResting, !ProcessInfo.processInfo.isRunningForPreviews else { return }
        hustleCount = min(hustleCount + 1, 60)
    }

    private func resetMeter() {
        hustleCount = 0
        isResting = false
    }

    private static func clamped(_ value: Int) -> Int {
        min(max(value, 0), 60)
    }
}

private extension ProcessInfo {
    var isRunningForPreviews: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

#Preview("Live Preview") {
    ContentView()
        .environment(\.colorScheme, .dark)
}

#Preview("Recovery Mode") {
    ContentView(initialHustleCount: 45, initialIsResting: true)
        .environment(\.colorScheme, .light)
}

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.12, green: 0.11, blue: 0.32),
                Color(red: 0.30, green: 0.18, blue: 0.56),
                Color(red: 0.98, green: 0.37, blue: 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
