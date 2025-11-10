import SwiftUI

struct AuthenticationFlowView: View {
    @State private var isShowingSignUp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                LogoHeader()
                Text("Unlock peer-to-peer gigs, goods, and services built for Gen Z entrepreneurs.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 24)
                VStack(spacing: 12) {
                    NavigationLink {
                        SignInView()
                    } label: {
                        PrimaryButton(label: "Log In")
                    }

                    Button {
                        isShowingSignUp = true
                    } label: {
                        Text("New here? Create account")
                            .font(.callout)
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 48)
            .sheet(isPresented: $isShowingSignUp) {
                NavigationStack {
                    SignUpView()
                }
            }
        }
    }
}
