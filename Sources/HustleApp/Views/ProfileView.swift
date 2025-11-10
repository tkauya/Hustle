import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var analyticsViewModel = ProfileAnalyticsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    profileHeader
                    earningsProgress
                    analyticsHighlights
                    reviewsShowcase
                }
                .padding(20)
            }
            .background(Color.backgroundSoft.ignoresSafeArea())
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Sign Out") {
                        session.signOut()
                    }
                }
            }
        }
    }

    private var profileHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Circle()
                    .fill(LinearGradient.hustleBrand)
                    .frame(width: 72, height: 72)
                    .overlay(
                        Text(session.currentUser?.fullName.initials ?? "HU")
                            .font(.title.bold())
                            .foregroundColor(.white)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.currentUser?.fullName ?? "Hustle Pro")
                        .font(.title2.bold())
                    HStack {
                        Label(String(format: "%.1f", session.currentUser?.rating ?? 0), systemImage: "star.fill")
                            .foregroundColor(Color.primaryPink)
                            .font(.caption)
                        Text("\(session.currentUser?.completedOrders ?? 0) sales completed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let tags = session.currentUser?.expertiseTags {
                        Text(tags.joined(separator: " · "))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.cardBackground)
        )
    }

    private var earningsProgress: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Earnings Progress")
                .font(.headline)
            ProgressView(value: analyticsViewModel.progress)
                .accentColor(.primaryPink)
                .scaleEffect(x: 1, y: 1.4, anchor: .center)
            if let snapshot = analyticsViewModel.currentSnapshot {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Gross earnings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(Formatters.currencyString(from: snapshot.grossEarnings, currencyCode: "USD"))
                            .font(.headline)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Net earnings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(Formatters.currencyString(from: snapshot.netEarnings, currencyCode: "USD"))
                            .font(.headline)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Growth")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(Formatters.percentString(from: analyticsViewModel.weeklyGrowth))
                            .font(.headline)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.cardBackground)
        )
    }

    private var analyticsHighlights: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance metrics")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                MetricCard(title: "Avg response", valueText: formattedTime(analyticsViewModel.currentSnapshot?.responseTime ?? 0), trend: "-34% vs last week")
                MetricCard(title: "On-time delivery", valueText: Formatters.percentString(from: analyticsViewModel.currentSnapshot?.onTimeDeliveryRate ?? 0), trend: "+5% vs last week")
                MetricCard(title: "Sales", valueText: String(analyticsViewModel.currentSnapshot?.salesCount ?? 0), trend: "+6 orders")
                MetricCard(title: "Purchases", valueText: String(analyticsViewModel.currentSnapshot?.purchasesCount ?? 0), trend: "-1 order")
            }
        }
    }

    private var reviewsShowcase: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Reviews")
                .font(.headline)
            ReviewCard(author: "collective.ai", rating: 5, message: "Loved the automation pack – shipped faster than promised and boosted our conversions overnight.")
            ReviewCard(author: "moxie.studio", rating: 5, message: "Easiest collab ever. Brief in the AM, polished assets by sunset. 🔥")
        }
    }

    private func formattedTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
}

private extension String {
    var initials: String {
        split(separator: " ")
            .compactMap { $0.first }
            .map(String.init)
            .joined()
    }
}

private struct MetricCard: View {
    let title: String
    let valueText: String
    var trend: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
            Text(valueText)
                .font(.title3.bold())
            Text(trend)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.cardBackground)
        )
    }
}

private struct ReviewCard: View {
    let author: String
    let rating: Int
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(author)
                    .font(.headline)
                Spacer()
                HStack(spacing: 2) {
                    ForEach(0..<rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.primaryPink)
                    }
                }
            }
            Text(message)
                .font(.subheadline)
            Text("Verified purchase")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.cardBackground)
        )
    }
}
