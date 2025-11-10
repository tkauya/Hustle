import Foundation
import Combine

final class ProfileAnalyticsViewModel: ObservableObject {
    @Published private(set) var snapshots: [PerformanceSnapshot]
    @Published private(set) var progress: Double = 0
    @Published private(set) var currentSnapshot: PerformanceSnapshot?
    @Published private(set) var previousSnapshot: PerformanceSnapshot?

    init(snapshots: [PerformanceSnapshot] = PreviewData.performanceSnapshots) {
        self.snapshots = snapshots
        self.currentSnapshot = snapshots.last
        self.previousSnapshot = snapshots.dropLast().last
        computeProgress()
    }

    private func computeProgress() {
        guard let current = currentSnapshot else { return }
        let target: Decimal = 5000
        let currentValue = NSDecimalNumber(decimal: current.grossEarnings).doubleValue
        let targetValue = NSDecimalNumber(decimal: target).doubleValue
        let progressValue = min(currentValue / targetValue, 1.0)
        progress = progressValue
    }

    var weeklyGrowth: Double {
        guard let current = currentSnapshot, let previous = previousSnapshot else { return 0 }
        let currentValue = NSDecimalNumber(decimal: current.grossEarnings).doubleValue
        let previousValue = NSDecimalNumber(decimal: previous.grossEarnings).doubleValue
        guard previousValue > 0 else { return 1.0 }
        return (currentValue - previousValue) / previousValue
    }
}
