import SwiftUI

struct LogoHeader: View {
    var body: some View {
        VStack(spacing: 16) {
            LinearGradient.hustleBrand
                .mask(
                    Text("HUSTLE")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                )
                .frame(height: 56)
            Text("Marketplace for creators & doers")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}
