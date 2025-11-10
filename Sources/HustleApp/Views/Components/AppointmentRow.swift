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
                        .foregroundStyle(Color.primaryPink)
                )
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.listingTitle)
                    .font(.headline)
                Text(transaction.occurredAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(transaction.amount, format: .currency(code: transaction.currencyCode))
                .font(.headline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.cardBackground)
        )
    }
}
