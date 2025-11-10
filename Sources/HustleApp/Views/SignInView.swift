import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var session: UserSession
    @State private var username: String = "ndochamp"
    @State private var password: String = "password"
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                LogoHeader()
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome back!")
                        .font(.title.bold())

                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username").font(.subheadline.weight(.semibold))
                            TextField("@username", text: $username)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .hustleInputBackground()
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password").font(.subheadline.weight(.semibold))
                            SecureField("Password", text: $password)
                                .hustleInputBackground()
                        }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    Button(action: submit) {
                        PrimaryButton(label: "Sign In", isLoading: isLoading)
                    }
                    .disabled(isLoading)
                }
            }
            .padding(24)
        }
        .background(Color.backgroundSoft.ignoresSafeArea())
        .navigationTitle("Sign In")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { presentationMode.wrappedValue.dismiss() }
            }
        }
    }

    private func submit() {
        errorMessage = nil
        isLoading = true
        session.signIn(username: username, password: password) { result in
            isLoading = false
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case let .failure(error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
