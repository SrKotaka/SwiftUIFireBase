//
//  SignInEmailView.swift
//  SwiftUIFireBase
//
//  Created by FELIPE LUVIZOTTO DE CASTRO on 17/05/24.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    
    func signUp() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "No email or password found."
            showErrorAlert = true
            return
        }
        do {
            try await AuthenticationManager.shared.createUser(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
    
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "No email or password found."
            showErrorAlert = true
            return
        }
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}



struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task {
                    await handleSignIn()
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Button {
                Task {
                    await handleSignUp()
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func handleSignIn() async {
        if !viewModel.email.isEmpty && !viewModel.password.isEmpty {
            await viewModel.signIn()
            if viewModel.errorMessage == nil {
                showSignInView = false
            }
        } else {
            viewModel.errorMessage = "No email or password found."
            viewModel.showErrorAlert = true
        }
    }
    
    private func handleSignUp() async {
        if !viewModel.email.isEmpty && !viewModel.password.isEmpty {
            await viewModel.signUp()
            if viewModel.errorMessage == nil {
                showSignInView = false
            }
        } else {
            viewModel.errorMessage = "No email or password found."
            viewModel.showErrorAlert = true
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
