import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var session: UserSession
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var accountType: User.AccountType = .seller
    @State private var isSubmitting = false

    var body: some View {
        Form {
            Section(header: Text("Account Details")) {
                TextField("Full name", text: $fullName)
                TextField("Username", text: $username)
                    .textInputAutocapitalization(.never)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                Picker("Account Type", selection: $accountType) {
                    ForEach(User.AccountType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
            }

            Section(footer: Text("Tap Sign Up to create your Hustle profile and start accepting payments in seconds.")) {
                Button(action: submit) {
                    if isSubmitting {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .navigationTitle("Create account")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") { dismiss() }
            }
        }
    }

    private func submit() {
        isSubmitting = true
        let newUser = User(
            username: username,
            fullName: fullName,
            accountType: accountType,
            rating: 0,
            completedOrders: 0,
            bio: "",
            joinedAt: Date(),
            expertiseTags: []
        )
        session.signUp(newUser: newUser) { _ in
            isSubmitting = false
            dismiss()
        }
    }
}
