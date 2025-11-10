import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Try \"logo design\" or \"TikTok editor\"", text: $viewModel.query)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                Section(header: Text("Results")) {
                    ForEach(viewModel.results) { listing in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(listing.title)
                                .font(.headline)
                            Text(listing.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Label(String(format: "%.1f", listing.rating), systemImage: "star.fill")
                                    .font(.caption)
                                    .foregroundColor(Color.primaryPink)
                                Text(Formatters.currencyString(from: listing.price, currencyCode: listing.currencyCode))
                                    .font(.subheadline.weight(.semibold))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Explore")
        }
    }
}
