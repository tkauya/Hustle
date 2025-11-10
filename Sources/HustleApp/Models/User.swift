import Foundation

public struct User: Identifiable, Codable, Hashable {
    public enum AccountType: String, Codable, CaseIterable {
        case buyer
        case seller
        case hybrid
    }

    public let id: UUID
    public var username: String
    public var fullName: String
    public var avatarURL: URL?
    public var accountType: AccountType
    public var rating: Double
    public var completedOrders: Int
    public var bio: String
    public var joinedAt: Date
    public var expertiseTags: [String]

    public init(
        id: UUID = UUID(),
        username: String,
        fullName: String,
        avatarURL: URL? = nil,
        accountType: AccountType,
        rating: Double,
        completedOrders: Int,
        bio: String,
        joinedAt: Date,
        expertiseTags: [String]
    ) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatarURL = avatarURL
        self.accountType = accountType
        self.rating = rating
        self.completedOrders = completedOrders
        self.bio = bio
        self.joinedAt = joinedAt
        self.expertiseTags = expertiseTags
    }
}

public struct UserSummary: Identifiable, Codable, Hashable {
    public let id: UUID
    public var username: String
    public var avatarURL: URL?
    public var rating: Double
    public var reviewCount: Int

    public init(
        id: UUID = UUID(),
        username: String,
        avatarURL: URL? = nil,
        rating: Double,
        reviewCount: Int
    ) {
        self.id = id
        self.username = username
        self.avatarURL = avatarURL
        self.rating = rating
        self.reviewCount = reviewCount
    }
}
