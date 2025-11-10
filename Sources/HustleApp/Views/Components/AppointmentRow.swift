import SwiftUI

struct AppointmentRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color.primaryPink.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "calendar.badge.clock")
                        .foregroundColor(Color.primaryPink)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.listingTitle)
                    .font(.headline)
                Text(transaction.occurredAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(Formatters.currencyString(from: transaction.amount, currencyCode: transaction.currencyCode))
                .font(.headline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.cardBackground)
        )
    }
}
