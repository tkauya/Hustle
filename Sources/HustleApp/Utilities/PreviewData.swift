import Foundation

public enum PreviewData {
    public static let categories: [MarketplaceCategory] = [
        MarketplaceCategory(name: "Design", iconName: "pencil.and.outline", colorHex: "#FF6B81"),
        MarketplaceCategory(name: "Development", iconName: "curlybraces.square", colorHex: "#5B8CFF"),
        MarketplaceCategory(name: "Music", iconName: "music.note", colorHex: "#50E3C2"),
        MarketplaceCategory(name: "Consulting", iconName: "person.2.fill", colorHex: "#F5A623"),
        MarketplaceCategory(name: "Lifestyle", iconName: "sparkles", colorHex: "#A855F7")
    ]

    public static let currentUser = User(
        username: "ndochamp",
        fullName: "Ndo Champ",
        accountType: .hybrid,
        rating: 4.9,
        completedOrders: 122,
        bio: "Product designer & automation engineer helping Gen Z launch side hustles.",
        joinedAt: Date(timeIntervalSinceNow: -60 * 60 * 24 * 365),
        expertiseTags: ["Design", "Automation", "Branding"]
    )

    public static let wallet: Wallet = {
        let sampleTransactions: [Transaction] = [
            Transaction(
                listingTitle: "Custom Notion Dashboard",
                counterparty: UserSummary(username: "collective.ai", rating: 4.8, reviewCount: 84),
                amount: 140,
                currencyCode: "USD",
                occurredAt: Date(timeIntervalSinceNow: -6 * 24 * 3600),
                type: .sale
            ),
            Transaction(
                listingTitle: "Lo-Fi Beat Pack",
                counterparty: UserSummary(username: "beatlab", rating: 4.6, reviewCount: 32),
                amount: 24,
                currencyCode: "USD",
                occurredAt: Date(timeIntervalSinceNow: -4 * 24 * 3600),
                type: .purchase
            ),
            Transaction(
                listingTitle: "Brand Playbook",
                counterparty: UserSummary(username: "moxie.studio", rating: 4.9, reviewCount: 210),
                amount: 320,
                currencyCode: "USD",
                occurredAt: Date(timeIntervalSinceNow: -2 * 24 * 3600),
                type: .sale
            ),
            Transaction(
                listingTitle: "Wallet Top Up",
                counterparty: UserSummary(username: "stripe", rating: 5.0, reviewCount: 999),
                amount: 200,
                currencyCode: "USD",
                occurredAt: Date(timeIntervalSinceNow: -24 * 3600),
                type: .deposit
            )
        ]
        return Wallet(balance: 540, currencyCode: "USD", transactions: sampleTransactions)
    }()

    public static let listings: [Listing] = {
        let user = UserSummary(username: "ndochamp", rating: 4.9, reviewCount: 180)
        return [
            Listing(
                title: "AI-Powered Social Kit",
                subtitle: "30-day TikTok + IG strategy",
                detail: "Automated content prompts, trending audio pairings, and analytics dashboard for creators.",
                category: categories[0],
                type: .digital,
                price: 140,
                currencyCode: "USD",
                rating: 4.9,
                reviewCount: 126,
                seller: user,
                media: [Listing.Media(url: URL(string: "https://example.com/socialkit.png")!)],
                tags: ["social", "templates", "marketing"],
                isFeatured: true,
                createdAt: Date(timeIntervalSinceNow: -3 * 24 * 3600)
            ),
            Listing(
                title: "Drop-in UI Squad",
                subtitle: "Design-to-code task force",
                detail: "Design system maintenance, responsive builds, and accessibility QA turned around in 24h.",
                category: categories[1],
                type: .service,
                price: 480,
                currencyCode: "USD",
                rating: 5.0,
                reviewCount: 52,
                seller: user,
                media: [Listing.Media(url: URL(string: "https://example.com/ui-squad.png")!)],
                tags: ["swiftui", "design", "dev"],
                isFeatured: true,
                createdAt: Date(timeIntervalSinceNow: -5 * 24 * 3600)
            ),
            Listing(
                title: "Gen Z Branding Lab",
                subtitle: "Personality-packed brand refresh",
                detail: "Logo, palette, typography, and merch kit targeted at Gen Z audiences.",
                category: categories[0],
                type: .service,
                price: 620,
                currencyCode: "USD",
                rating: 4.8,
                reviewCount: 98,
                seller: user,
                media: [Listing.Media(url: URL(string: "https://example.com/branding.png")!)],
                tags: ["branding", "logo", "identity"],
                isFeatured: false,
                createdAt: Date(timeIntervalSinceNow: -8 * 24 * 3600)
            )
        ]
    }()

    public static let performanceSnapshots: [PerformanceSnapshot] = {
        let calendar = Calendar.current
        let now = Date()
        let currentPeriod = DateInterval(start: calendar.date(byAdding: .day, value: -7, to: now)!, end: now)
        let previousPeriod = DateInterval(start: calendar.date(byAdding: .day, value: -14, to: now)!, end: calendar.date(byAdding: .day, value: -7, to: now)!)
        return [
            PerformanceSnapshot(
                period: previousPeriod,
                salesCount: 12,
                purchasesCount: 3,
                grossEarnings: 2200,
                netEarnings: 1850,
                responseTime: 2.4 * 3600,
                onTimeDeliveryRate: 0.92
            ),
            PerformanceSnapshot(
                period: currentPeriod,
                salesCount: 18,
                purchasesCount: 4,
                grossEarnings: 3120,
                netEarnings: 2700,
                responseTime: 1.6 * 3600,
                onTimeDeliveryRate: 0.97
            )
        ]
    }()
}
