import SwiftUI

struct CategoryCard: View {
    let category: MarketplaceCategory

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient.hustleBrand
                .opacity(0.25)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: category.iconName)
                    .font(.title2)
                    .foregroundStyle(Color.primaryPink)
                    .padding(12)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                Spacer()
                Text(category.name)
                    .font(.headline)
                Text("67 live offers")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(20)
        }
        .frame(height: 160)
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 8)
    }
}
