import SwiftUI

struct WalletView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var viewModel = WalletViewModel()
    @State private var addAmount: Decimal = 100

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Balance")) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(viewModel.wallet.balance, format: .currency(code: viewModel.wallet.currencyCode))
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                        HStack(spacing: 16) {
                            VStack(alignment: .leading) {
                                Text("Net Earnings")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(viewModel.wallet.netEarnings, format: .currency(code: viewModel.wallet.currencyCode))
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Total Sales")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(viewModel.wallet.totalSales, format: .currency(code: viewModel.wallet.currencyCode))
                                    .font(.headline)
                            }
                        }
                        Button {
                            viewModel.showAddFundsSheet = true
                        } label: {
                            Text("Add funds")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }

                Section(header: Text("Activity")) {
                    ForEach(viewModel.wallet.transactions) { transaction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.listingTitle)
                                    .font(.headline)
                                Text(transaction.occurredAt, style: .date)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(transaction.amount, format: .currency(code: transaction.currencyCode))
                                .font(.headline)
                                .foregroundStyle(transaction.type == .purchase ? .red : .green)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Wallet")
            .onAppear {
                viewModel.sync(with: session.wallet)
            }
            .onReceive(session.$wallet) { wallet in
                viewModel.sync(with: wallet)
            }
            .sheet(isPresented: $viewModel.showAddFundsSheet) {
                NavigationStack {
                    Form {
                        Section(header: Text("Amount")) {
                            TextField("Amount", value: $addAmount, format: .currency(code: viewModel.wallet.currencyCode))
                                .keyboardType(.decimalPad)
                        }
                        Section {
                            Button("Confirm Deposit") {
                                let updated = viewModel.deposit(amount: addAmount)
                                session.updateWallet(updated)
                                viewModel.showAddFundsSheet = false
                            }
                        }
                    }
                    .navigationTitle("Add funds")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") { viewModel.showAddFundsSheet = false }
                        }
                    }
                }
            }
        }
    }
}
