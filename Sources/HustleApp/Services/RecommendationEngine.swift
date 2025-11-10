import Foundation

public protocol RecommendationEngine {
    func recommendations(for user: User?, listings: [Listing]) -> [Listing]
}

/// Heuristic ranking that blends collaborative-like scoring with freshness and quality signals.
public struct HybridRecommendationEngine: RecommendationEngine {
    public struct Configuration {
        public var ratingWeight: Double
        public var recencyWeight: Double
        public var engagementWeight: Double
        public var tagMatchWeight: Double
        public var featuredBoost: Double

        public init(
            ratingWeight: Double = 0.35,
            recencyWeight: Double = 0.25,
            engagementWeight: Double = 0.2,
            tagMatchWeight: Double = 0.15,
            featuredBoost: Double = 0.05
        ) {
            self.ratingWeight = ratingWeight
            self.recencyWeight = recencyWeight
            self.engagementWeight = engagementWeight
            self.tagMatchWeight = tagMatchWeight
            self.featuredBoost = featuredBoost
        }
    }

    private let configuration: Configuration
    private let calendar: Calendar

    public init(configuration: Configuration = Configuration(), calendar: Calendar = .current) {
        self.configuration = configuration
        self.calendar = calendar
    }

    public func recommendations(for user: User?, listings: [Listing]) -> [Listing] {
        listings
            .sorted { lhs, rhs in
                score(for: lhs, user: user) > score(for: rhs, user: user)
            }
    }

    private func score(for listing: Listing, user: User?) -> Double {
        let ratingScore = listing.rating / 5.0
        let engagementScore = min(Double(listing.reviewCount) / 150.0, 1.0)

        let daysSinceCreation = calendar.dateComponents([.day], from: listing.createdAt, to: Date()).day ?? 0
        let recencyScore = max(0, 1.0 - Double(daysSinceCreation) / 14.0)

        let tagMatchScore: Double
        if let user {
            let overlap = Set(listing.tags).intersection(user.expertiseTags).count
            tagMatchScore = min(Double(overlap) / 3.0, 1.0)
        } else {
            tagMatchScore = 0.3
        }

        let featuredScore = listing.isFeatured ? 1.0 : 0.0

        return ratingScore * configuration.ratingWeight
            + recencyScore * configuration.recencyWeight
            + engagementScore * configuration.engagementWeight
            + tagMatchScore * configuration.tagMatchWeight
            + featuredScore * configuration.featuredBoost
    }
}
