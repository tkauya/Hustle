import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var session: UserSession

    var body: some View {
        TabView {
            FeedView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            ExploreView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            WalletView()
                .tabItem {
                    Label("Wallet", systemImage: "creditcard.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .accentColor(.primaryPink)
    }
}
