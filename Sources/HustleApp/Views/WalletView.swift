import SwiftUI

struct WalletView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var viewModel = WalletViewModel()
    @State private var addAmountInput: String = "100"

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Balance")) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(Formatters.currencyString(from: viewModel.wallet.balance, currencyCode: viewModel.wallet.currencyCode))
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                        HStack(spacing: 16) {
                            VStack(alignment: .leading) {
                                Text("Net Earnings")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(Formatters.currencyString(from: viewModel.wallet.netEarnings, currencyCode: viewModel.wallet.currencyCode))
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Total Sales")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(Formatters.currencyString(from: viewModel.wallet.totalSales, currencyCode: viewModel.wallet.currencyCode))
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
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(Formatters.currencyString(from: transaction.amount, currencyCode: transaction.currencyCode))
                                .font(.headline)
                                .foregroundColor(transaction.type == .purchase ? .red : .green)
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
                NavigationView {
                    Form {
                        Section(header: Text("Amount")) {
                            TextField("Amount", text: $addAmountInput)
                                .keyboardType(.decimalPad)
                        }
                        Section {
                            Button("Confirm Deposit") {
                                let sanitized = addAmountInput.replacingOccurrences(of: ",", with: ".")
                                if let amount = Decimal(string: sanitized) {
                                    let updated = viewModel.deposit(amount: amount)
                                    session.updateWallet(updated)
                                    addAmountInput = ""
                                    viewModel.showAddFundsSheet = false
                                }
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
