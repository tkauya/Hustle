import Foundation
import Combine

public final class UserSession: ObservableObject {
    @Published public private(set) var currentUser: User?
    @Published public private(set) var wallet: Wallet
    @Published public private(set) var isAuthenticated: Bool

    public init(currentUser: User? = PreviewData.currentUser, wallet: Wallet = PreviewData.wallet) {
        self.currentUser = currentUser
        self.wallet = wallet
        self.isAuthenticated = currentUser != nil
    }

    public func signIn(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            guard password.count >= 4 else {
                completion(.failure(AuthenticationError.invalidCredentials))
                return
            }
            let user = PreviewData.currentUser
            self.currentUser = user
            self.wallet = PreviewData.wallet
            self.isAuthenticated = true
            completion(.success(user))
        }
    }

    public func signUp(newUser: User, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.currentUser = newUser
            self.wallet = Wallet(balance: 0, currencyCode: "USD", transactions: [])
            self.isAuthenticated = true
            completion(.success(newUser))
        }
    }

    public func signOut() {
        currentUser = nil
        isAuthenticated = false
    }

    public func updateWallet(_ wallet: Wallet) {
        self.wallet = wallet
    }
}

public extension UserSession {
    enum AuthenticationError: LocalizedError {
        case invalidCredentials

        public var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return "The username or password you entered is incorrect."
            }
        }
    }
}
