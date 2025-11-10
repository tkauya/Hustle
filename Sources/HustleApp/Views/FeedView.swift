import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SearchField()
                        .padding(.top)

                    FeaturedCategoriesGrid(categories: PreviewData.categories)

                    if !viewModel.upcomingAppointments.isEmpty {
                        UpcomingAppointmentsSection(appointments: viewModel.upcomingAppointments)
                    }

                    ListingsSection(title: "Trending For You", listings: viewModel.recommendedListings)
                    ListingsSection(title: "Featured", listings: viewModel.featuredListings)
                }
                .padding(.horizontal, 20)
            }
            .background(Color.backgroundSoft.ignoresSafeArea())
            .navigationTitle("Hustle")
        }
    }
}

private struct SearchField: View {
    @State private var query: String = ""

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search gigs, drops, and services", text: $query)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct FeaturedCategoriesGrid: View {
    let categories: [MarketplaceCategory]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Discover")
                .font(.title3.bold())
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(categories) { category in
                    CategoryCard(category: category)
                }
            }
        }
    }
}

private struct ListingsSection: View {
    let title: String
    let listings: [Listing]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title3.bold())
                Spacer()
                Button("See all") {}
                    .font(.subheadline.weight(.semibold))
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(listings) { listing in
                        ListingCard(listing: listing)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

private struct UpcomingAppointmentsSection: View {
    let appointments: [Transaction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming")
                .font(.title3.bold())
            ForEach(appointments) { appointment in
                AppointmentRow(transaction: appointment)
            }
        }
    }
}
