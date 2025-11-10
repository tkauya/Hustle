import SwiftUI

public extension Color {
    static let primaryPink = Color(red: 0.95, green: 0.35, blue: 0.55)
    static let gradientTeal = Color(red: 0.43, green: 0.90, blue: 0.82)
    static let backgroundSoft = Color(red: 0.95, green: 0.96, blue: 0.98)
    static let cardBackground = Color.white.opacity(0.94)
}

public extension LinearGradient {
    static var hustleBrand: LinearGradient {
        LinearGradient(
            colors: [.primaryPink, .gradientTeal],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
