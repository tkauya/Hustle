import Foundation

public struct Transaction: Identifiable, Codable, Hashable {
    public enum TransactionType: String, Codable {
        case sale
        case purchase
        case deposit
        case withdrawal
    }

    public let id: UUID
    public var listingTitle: String
    public var counterparty: UserSummary
    public var amount: Decimal
    public var currencyCode: String
    public var occurredAt: Date
    public var type: TransactionType

    public init(
        id: UUID = UUID(),
        listingTitle: String,
        counterparty: UserSummary,
        amount: Decimal,
        currencyCode: String,
        occurredAt: Date,
        type: TransactionType
    ) {
        self.id = id
        self.listingTitle = listingTitle
        self.counterparty = counterparty
        self.amount = amount
        self.currencyCode = currencyCode
        self.occurredAt = occurredAt
        self.type = type
    }
}

public struct PerformanceSnapshot: Identifiable, Codable, Hashable {
    public let id: UUID
    public var period: DateInterval
    public var salesCount: Int
    public var purchasesCount: Int
    public var grossEarnings: Decimal
    public var netEarnings: Decimal
    public var responseTime: TimeInterval
    public var onTimeDeliveryRate: Double

    public init(
        id: UUID = UUID(),
        period: DateInterval,
        salesCount: Int,
        purchasesCount: Int,
        grossEarnings: Decimal,
        netEarnings: Decimal,
        responseTime: TimeInterval,
        onTimeDeliveryRate: Double
    ) {
        self.id = id
        self.period = period
        self.salesCount = salesCount
        self.purchasesCount = purchasesCount
        self.grossEarnings = grossEarnings
        self.netEarnings = netEarnings
        self.responseTime = responseTime
        self.onTimeDeliveryRate = onTimeDeliveryRate
    }
}
