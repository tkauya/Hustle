import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    @Published private(set) var featuredListings: [Listing] = []
    @Published private(set) var recommendedListings: [Listing] = []
    @Published private(set) var upcomingAppointments: [Transaction] = []

    private let recommendationEngine: RecommendationEngine

    init(recommendationEngine: RecommendationEngine = HybridRecommendationEngine()) {
        self.recommendationEngine = recommendationEngine
        load()
    }

    func load(user: User? = PreviewData.currentUser) {
        let listings = PreviewData.listings
        featuredListings = listings.filter { $0.isFeatured }
        recommendedListings = recommendationEngine.recommendations(for: user, listings: listings)
        let appointments = PreviewData.wallet.transactions.filter { $0.type == .purchase }.prefix(3)
        upcomingAppointments = Array(appointments)
    }
}
