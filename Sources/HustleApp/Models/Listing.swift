import Foundation

public struct Listing: Identifiable, Codable, Hashable {
    public enum ListingType: String, Codable {
        case physical
        case digital
        case service
    }

    public struct Media: Identifiable, Codable, Hashable {
        public let id: UUID
        public var url: URL
        public var isVideo: Bool

        public init(id: UUID = UUID(), url: URL, isVideo: Bool = false) {
            self.id = id
            self.url = url
            self.isVideo = isVideo
        }
    }

    public let id: UUID
    public var title: String
    public var subtitle: String
    public var detail: String
    public var category: MarketplaceCategory
    public var type: ListingType
    public var price: Decimal
    public var currencyCode: String
    public var rating: Double
    public var reviewCount: Int
    public var seller: UserSummary
    public var media: [Media]
    public var tags: [String]
    public var isFeatured: Bool
    public var createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        detail: String,
        category: MarketplaceCategory,
        type: ListingType,
        price: Decimal,
        currencyCode: String,
        rating: Double,
        reviewCount: Int,
        seller: UserSummary,
        media: [Media],
        tags: [String],
        isFeatured: Bool,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.category = category
        self.type = type
        self.price = price
        self.currencyCode = currencyCode
        self.rating = rating
        self.reviewCount = reviewCount
        self.seller = seller
        self.media = media
        self.tags = tags
        self.isFeatured = isFeatured
        self.createdAt = createdAt
    }
}

public struct MarketplaceCategory: Identifiable, Codable, Hashable {
    public let id: UUID
    public var name: String
    public var heroImageURL: URL?
    public var iconName: String
    public var colorHex: String

    public init(id: UUID = UUID(), name: String, heroImageURL: URL? = nil, iconName: String, colorHex: String) {
        self.id = id
        self.name = name
        self.heroImageURL = heroImageURL
        self.iconName = iconName
        self.colorHex = colorHex
    }
}
