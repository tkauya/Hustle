#if canImport(SwiftUI)
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: FocusSessionViewModel
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init() {
        _viewModel = StateObject(wrappedValue: FocusSessionViewModel())
    }

    init(viewModel: FocusSessionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    SessionHeader(viewModel: viewModel)
                    FocusControls(viewModel: viewModel)
                    MilestoneList(viewModel: viewModel)
                    NotesPanel(notes: $viewModel.notes)
                }
                .padding(24)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Hustle Planner")
            .toolbar { toolbar }
        }
        .onReceive(timer) { _ in
            viewModel.advanceTimer()
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.phase)
        .overlay(alignment: .top) {
            if let message = viewModel.celebrationMessage {
                CelebrationBanner(message: message) {
                    viewModel.dismissCelebration()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding()
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(role: .destructive) {
                withAnimation(.spring()) {
                    viewModel.reset()
                }
            } label: {
                Label("Reset session", systemImage: "arrow.uturn.backward")
            }
            .disabled(viewModel.isPristine)
        }
    }
}

// MARK: - Session header

private struct SessionHeader: View {
    @ObservedObject var viewModel: FocusSessionViewModel

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text(viewModel.focusArea.title)
                    .font(.title2.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(viewModel.focusDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ProgressPanel(viewModel: viewModel)

            HStack(spacing: 12) {
                StatTile(title: "Elapsed", value: viewModel.elapsedLabel, icon: "timer")
                StatTile(title: "Remaining", value: viewModel.remainingLabel, icon: "hourglass")
                StatTile(title: "Energy", value: viewModel.energyTip, icon: "bolt.heart")
            }
        }
        .padding(24)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(alignment: .topTrailing) {
            PhaseTag(phase: viewModel.phase)
                .padding(16)
        }
    }
}

private struct ProgressPanel: View {
    @ObservedObject var viewModel: FocusSessionViewModel

    var body: some View {
        HStack(spacing: 24) {
            ZStack {
                Circle()
                    .strokeBorder(.quaternary, lineWidth: 12)
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(AngularGradient(colors: viewModel.ringColors, center: .center), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.progress)
                VStack(spacing: 4) {
                    Text(viewModel.progressLabel)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Text(viewModel.elapsedLabel)
                        .font(.title2.monospacedDigit())
                }
            }
            .frame(width: 140, height: 140)

            VStack(alignment: .leading, spacing: 12) {
                Label { Text("Daily streak") } icon: { Image(systemName: "flame.fill") }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(viewModel.streakDescription)
                    .font(.title3.weight(.semibold))

                Divider()

                Label { Text("Today's insight") } icon: { Image(systemName: "lightbulb") }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(viewModel.insight)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct StatTile: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
            Text(value)
                .font(.headline.monospacedDigit())
            Text(title.uppercased())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct PhaseTag: View {
    let phase: FocusSessionViewModel.Phase

    var body: some View {
        Text(phase.label)
            .font(.caption.bold())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(phase.tint.gradient, in: Capsule())
            .foregroundStyle(.white)
    }
}

// MARK: - Controls

private struct FocusControls: View {
    @ObservedObject var viewModel: FocusSessionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Session controls")
                .font(.headline)
                .foregroundStyle(.secondary)

            Picker("Focus", selection: $viewModel.focusArea) {
                ForEach(FocusSessionViewModel.FocusArea.allCases) { area in
                    Text(area.title).tag(area)
                }
            }
            .pickerStyle(.segmented)

            Stepper(value: $viewModel.goalMinutes, in: 15...180, step: 5) {
                Label("Goal: \(viewModel.goalMinutes) minutes", systemImage: "target")
            }

            Toggle(isOn: $viewModel.isResting.animation(.easeInOut(duration: 0.2))) {
                Label(viewModel.restLabel, systemImage: viewModel.isResting ? "powersleep" : "bolt.fill")
            }

            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    viewModel.startOrPause()
                }
            } label: {
                Label(viewModel.primaryActionLabel, systemImage: viewModel.primaryActionIcon)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

// MARK: - Milestones

private struct MilestoneList: View {
    @ObservedObject var viewModel: FocusSessionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Milestones")
                .font(.headline)
                .foregroundStyle(.secondary)

            ForEach(viewModel.milestones) { milestone in
                MilestoneRow(milestone: milestone, state: viewModel.state(for: milestone))
            }
        }
        .padding(24)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

private struct MilestoneRow: View {
    let milestone: FocusSessionViewModel.Milestone
    let state: FocusSessionViewModel.MilestoneState

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: state.icon)
                .foregroundStyle(state.tint)
                .font(.title3)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(milestone.title)
                    .font(.headline)
                Text(milestone.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(milestone.targetMinutes)m")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Notes

private struct NotesPanel: View {
    @Binding var notes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily notes")
                .font(.headline)
                .foregroundStyle(.secondary)
            TextEditor(text: $notes)
                .frame(minHeight: 120)
                .scrollContentBackground(.hidden)
                .padding(16)
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

// MARK: - Celebration banner

private struct CelebrationBanner: View {
    let message: String
    let dismiss: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.title3)
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            Spacer()
            Button("Close", action: dismiss)
                .buttonStyle(.bordered)
        }
        .padding()
        .background(.regularMaterial, in: Capsule(style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 12)
    }
}

#if DEBUG
#Preview("Dashboard") {
    ContentView(viewModel: .preview)
}
#endif

#endif
