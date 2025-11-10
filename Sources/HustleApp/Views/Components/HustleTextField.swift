import SwiftUI

private struct HustleInputBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

extension View {
    func hustleInputBackground() -> some View {
        modifier(HustleInputBackground())
    }
}
