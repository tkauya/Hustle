import Foundation

public protocol WalletService {
    func deposit(amount: Decimal, into wallet: Wallet) -> Wallet
    func withdraw(amount: Decimal, from wallet: Wallet) -> Wallet
    func record(transaction: Transaction, in wallet: Wallet) -> Wallet
}

public struct DefaultWalletService: WalletService {
    public init() {}

    public func deposit(amount: Decimal, into wallet: Wallet) -> Wallet {
        var updated = wallet
        updated.balance += amount
        let transaction = Transaction(
            listingTitle: "Wallet Deposit",
            counterparty: UserSummary(username: "stripe", rating: 5.0, reviewCount: 1000),
            amount: amount,
            currencyCode: wallet.currencyCode,
            occurredAt: Date(),
            type: .deposit
        )
        updated.transactions.insert(transaction, at: 0)
        return updated
    }

    public func withdraw(amount: Decimal, from wallet: Wallet) -> Wallet {
        var updated = wallet
        updated.balance -= amount
        let transaction = Transaction(
            listingTitle: "Wallet Withdrawal",
            counterparty: UserSummary(username: "stripe", rating: 5.0, reviewCount: 1000),
            amount: amount,
            currencyCode: wallet.currencyCode,
            occurredAt: Date(),
            type: .withdrawal
        )
        updated.transactions.insert(transaction, at: 0)
        return updated
    }

    public func record(transaction: Transaction, in wallet: Wallet) -> Wallet {
        var updated = wallet
        updated.transactions.insert(transaction, at: 0)
        switch transaction.type {
        case .sale, .deposit:
            updated.balance += transaction.amount
        case .purchase, .withdrawal:
            updated.balance -= transaction.amount
        }
        return updated
    }
}
