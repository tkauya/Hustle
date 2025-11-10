import SwiftUI

struct PrimaryButton: View {
    var label: String
    var isLoading: Bool = false

    var body: some View {
        ZStack {
            Text(label.uppercased())
                .opacity(isLoading ? 0 : 1)
            if isLoading {
                ProgressView()
                    .accentColor(.white)
            }
        }
        .font(.headline.weight(.heavy))
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(LinearGradient.hustleBrand)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .primaryPink.opacity(0.35), radius: 12, y: 8)
        .padding(.horizontal, 24)
    }
}
