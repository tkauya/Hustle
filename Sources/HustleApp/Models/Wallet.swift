import Foundation

public struct Wallet: Codable, Hashable {
    public var balance: Decimal
    public var currencyCode: String
    public var transactions: [Transaction]

    public init(balance: Decimal, currencyCode: String, transactions: [Transaction]) {
        self.balance = balance
        self.currencyCode = currencyCode
        self.transactions = transactions
    }

    public var totalSales: Decimal {
        transactions
            .filter { $0.type == .sale }
            .reduce(.zero) { $0 + $1.amount }
    }

    public var totalPurchases: Decimal {
        transactions
            .filter { $0.type == .purchase }
            .reduce(.zero) { $0 + $1.amount }
    }

    public var netEarnings: Decimal {
        totalSales - totalPurchases
    }
}
