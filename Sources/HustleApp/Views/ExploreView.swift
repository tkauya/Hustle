import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Try \"logo design\" or \"TikTok editor\"", text: $viewModel.query)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section(header: Text("Results")) {
                    ForEach(viewModel.results) { listing in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(listing.title)
                                .font(.headline)
                            Text(listing.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            HStack {
                                Label(String(format: "%.1f", listing.rating), systemImage: "star.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.primaryPink)
                                Text(listing.price, format: .currency(code: listing.currencyCode))
                                    .font(.subheadline.weight(.semibold))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Explore")
        }
    }
}
