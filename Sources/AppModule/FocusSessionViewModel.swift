#if canImport(SwiftUI)
import SwiftUI

@MainActor
final class FocusSessionViewModel: ObservableObject {
    @Published var focusArea: FocusArea
    @Published var goalMinutes: Int
    @Published var isResting: Bool
    @Published private(set) var elapsedSeconds: Int
    @Published private(set) var phase: Phase
    @Published var notes: String
    @Published private(set) var celebrationMessage: String?

    private var lastTick: Date
    @Published private(set) var milestones: [Milestone]

    var isPristine: Bool { elapsedSeconds == 0 && notes.isEmpty }

    init(
        focusArea: FocusArea = .deepWork,
        goalMinutes: Int = 60,
        isResting: Bool = false,
        elapsedSeconds: Int = 0,
        phase: Phase = .planning,
        notes: String = "",
        milestones: [Milestone] = Milestone.defaultMilestones
    ) {
        self.focusArea = focusArea
        self.goalMinutes = goalMinutes
        self.isResting = isResting
        self.elapsedSeconds = elapsedSeconds
        self.phase = phase
        self.notes = notes
        self.celebrationMessage = nil
        self.lastTick = .now
        self.milestones = milestones
    }

    // MARK: - Derived properties

    var progress: Double {
        guard goalMinutes > 0 else { return 0 }
        let percent = Double(elapsedSeconds) / Double(goalMinutes * 60)
        return min(max(percent, 0), 1)
    }

    var progressLabel: String {
        "\(Int(progress * 100))%"
    }

    var elapsedLabel: String {
        elapsedSeconds.formattedTime
    }

    var remainingLabel: String {
        let remaining = max(goalMinutes * 60 - elapsedSeconds, 0)
        return remaining.formattedTime
    }

    var focusDescription: String {
        focusArea.description
    }

    var energyTip: String {
        focusArea.energyTip
    }

    var ringColors: [Color] {
        focusArea.gradient
    }

    var restLabel: String {
        isResting ? "Resting" : "Active"
    }

    var primaryActionLabel: String {
        switch phase {
        case .planning:
            return "Start session"
        case .focusing:
            return isResting ? "Resume focus" : "Pause focus"
        case .resting:
            return "Resume focus"
        case .completed:
            return "Restart"
        }
    }

    var primaryActionIcon: String {
        switch phase {
        case .planning:
            return "play.fill"
        case .focusing:
            return isResting ? "play.fill" : "pause.fill"
        case .resting:
            return "play.fill"
        case .completed:
            return "arrow.clockwise"
        }
    }

    var streakDescription: String {
        "3 day streak"
    }

    var insight: String {
        switch focusArea {
        case .deepWork:
            return "Protect the next \(focusArea.recommendedBreak) minutes for focused creation."
        case .learning:
            return "Summarise key learnings after each \(focusArea.recommendedBreak)-minute block."
        case .shipping:
            return "Wrap with a short demo so progress stays visible."
        case .recharge:
            return "Use intentional rest to come back sharper for the next sprint."
        }
    }

    var milestonesReached: Int {
        milestones.filter { state(for: $0) == .completed }.count
    }

    // MARK: - Intentions

    func advanceTimer(date: Date = .now) {
        guard phase.isActive else {
            lastTick = date
            return
        }

        if isResting {
            phase = .resting
            lastTick = date
            return
        }

        let delta = Int(date.timeIntervalSince(lastTick).rounded())
        guard delta > 0 else { return }

        elapsedSeconds += delta
        lastTick = date

        if elapsedSeconds >= goalMinutes * 60 {
            elapsedSeconds = goalMinutes * 60
            phase = .completed
            triggerCelebration()
        } else {
            phase = .focusing
        }
    }

    func startOrPause() {
        switch phase {
        case .planning:
            phase = .focusing
            lastTick = .now
        case .focusing:
            isResting.toggle()
            phase = isResting ? .resting : .focusing
            if !isResting {
                lastTick = .now
            }
        case .resting:
            isResting = false
            phase = .focusing
            lastTick = .now
        case .completed:
            reset()
        }
    }

    func reset() {
        focusArea = .deepWork
        goalMinutes = 60
        isResting = false
        elapsedSeconds = 0
        phase = .planning
        notes = ""
        celebrationMessage = nil
        lastTick = .now
    }

    func state(for milestone: Milestone) -> MilestoneState {
        let elapsedMinutes = elapsedSeconds / 60
        if elapsedMinutes >= milestone.targetMinutes {
            return .completed
        }
        let nextTarget = Double(milestone.targetMinutes) / Double(goalMinutes)
        if progress >= nextTarget * 0.7 {
            return .inProgress
        }
        return .upcoming
    }

    func dismissCelebration() {
        celebrationMessage = nil
    }

    private func triggerCelebration() {
        guard celebrationMessage == nil else { return }
        celebrationMessage = "Session goal complete! Celebrate the momentum."
    }
}

// MARK: - Support types

extension FocusSessionViewModel {
    enum Phase: Equatable {
        case planning
        case focusing
        case resting
        case completed

        var label: String {
            switch self {
            case .planning: return "Planning"
            case .focusing: return "Focusing"
            case .resting: return "Rest"
            case .completed: return "Completed"
            }
        }

        var tint: Color {
            switch self {
            case .planning: return .blue
            case .focusing: return .green
            case .resting: return .orange
            case .completed: return .purple
            }
        }

        var isActive: Bool {
            switch self {
            case .planning, .completed:
                return false
            case .focusing, .resting:
                return true
            }
        }
    }

    enum FocusArea: String, CaseIterable, Identifiable {
        case deepWork
        case learning
        case shipping
        case recharge

        var id: String { rawValue }

        var title: String {
            switch self {
            case .deepWork: return "Deep work"
            case .learning: return "Learning"
            case .shipping: return "Shipping"
            case .recharge: return "Recharge"
            }
        }

        var description: String {
            switch self {
            case .deepWork:
                return "Block notifications and dive into a creative sprint."
            case .learning:
                return "Keep notes handy and summarise concepts as you go."
            case .shipping:
                return "Break features down so you can ship steady increments."
            case .recharge:
                return "Slow down intentionally so your next sprint is sharper."
            }
        }

        var energyTip: String {
            switch self {
            case .deepWork:
                return "Hydrate and stretch every \(recommendedBreak) minutes."
            case .learning:
                return "Teach back the concept to cement it."
            case .shipping:
                return "Sync with stakeholders at the halfway point."
            case .recharge:
                return "Protect this break like any important meeting."
            }
        }

        var gradient: [Color] {
            switch self {
            case .deepWork:
                return [.purple, .indigo]
            case .learning:
                return [.mint, .teal]
            case .shipping:
                return [.orange, .pink]
            case .recharge:
                return [.blue, .cyan]
            }
        }

        var recommendedBreak: Int {
            switch self {
            case .deepWork: return 50
            case .learning: return 40
            case .shipping: return 45
            case .recharge: return 20
            }
        }
    }

    struct Milestone: Identifiable {
        let id = UUID()
        let title: String
        let detail: String
        let targetMinutes: Int

        static let defaultMilestones: [Milestone] = [
            Milestone(title: "Warm up", detail: "Outline the goal and prep context.", targetMinutes: 10),
            Milestone(title: "Halfway", detail: "Review progress and adjust plan.", targetMinutes: 30),
            Milestone(title: "Finish strong", detail: "Ship or summarise the outcome.", targetMinutes: 60)
        ]
    }

    enum MilestoneState {
        case upcoming
        case inProgress
        case completed

        var icon: String {
            switch self {
            case .upcoming: return "circle"
            case .inProgress: return "clock"
            case .completed: return "checkmark.circle.fill"
            }
        }

        var tint: Color {
            switch self {
            case .upcoming: return .gray
            case .inProgress: return .blue
            case .completed: return .green
            }
        }
    }
}

private extension Int {
    var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: TimeInterval(self)) ?? "0s"
    }
}

#if DEBUG
extension FocusSessionViewModel {
    static var preview: FocusSessionViewModel {
        FocusSessionViewModel(
            focusArea: .shipping,
            goalMinutes: 75,
            isResting: false,
            elapsedSeconds: 24 * 60,
            phase: .focusing,
            notes: "Ship the design refresh and capture learnings."
        )
    }
}
#endif

#endif
