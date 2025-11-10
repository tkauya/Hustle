import SwiftUI

struct ListingCard: View {
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.cardBackground)
                    .frame(width: 240, height: 160)
                    .overlay(
                        LinearGradient.hustleBrand
                            .opacity(0.35)
                    )
                if listing.isFeatured {
                    Text("Featured")
                        .font(.caption2.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.85))
                        .clipShape(Capsule())
                        .padding(12)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(listing.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(listing.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    Label(String(format: "%.1f", listing.rating), systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(Color.primaryPink)
                    Text("· \(listing.reviewCount) reviews")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(Formatters.currencyString(from: listing.price, currencyCode: listing.currencyCode))
                    .font(.headline)
            }
            .frame(width: 240, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.cardBackground)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 12, y: 8)
    }
}
