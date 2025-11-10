import Foundation
import Combine

final class WalletViewModel: ObservableObject {
    @Published private(set) var wallet: Wallet
    @Published var showAddFundsSheet: Bool = false

    private let walletService: WalletService

    init(wallet: Wallet = PreviewData.wallet, walletService: WalletService = DefaultWalletService()) {
        self.wallet = wallet
        self.walletService = walletService
    }

    func sync(with wallet: Wallet) {
        self.wallet = wallet
    }

    @discardableResult
    func deposit(amount: Decimal) -> Wallet {
        let updated = walletService.deposit(amount: amount, into: wallet)
        wallet = updated
        return updated
    }

    @discardableResult
    func withdraw(amount: Decimal) -> Wallet {
        let updated = walletService.withdraw(amount: amount, from: wallet)
        wallet = updated
        return updated
    }
}
