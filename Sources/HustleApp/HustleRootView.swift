import SwiftUI

/// Entry point view for the Hustle marketplace experience.
/// Embed this view inside an `@main` App structure inside an Xcode project
/// or a scene delegate when integrating into an existing code base.
public struct HustleRootView: View {
    @StateObject private var session = UserSession()

    public init() {}

    public var body: some View {
        Group {
            if session.isAuthenticated {
                MainTabView()
                    .environmentObject(session)
            } else {
                AuthenticationFlowView()
                    .environmentObject(session)
            }
        }
    }
}

struct HustleRootView_Previews: PreviewProvider {
    static var previews: some View {
        HustleRootView()
    }
}
