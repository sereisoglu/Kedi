//
//  SignInScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import SwiftUI

struct SignInScreen: View {
    
    @StateObject private var viewModel = SignInViewModel()
    
    @FocusState private var focusedField: SignInViewModel.Field?
    
    var body: some View {
        Form {
            Section {
                TextField("Email", text: $viewModel.email)
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
            } header: {
                Text("Email")
            } footer: {
                if let emailPrompt = viewModel.emailPrompt {
                    Text(emailPrompt)
                        .foregroundStyle(Color.red)
                }
            }
            .listSectionSpacing(.compact)
            
            Section {
                SecureField("Password", text: $viewModel.password)
                    .focused($focusedField, equals: .password)
            } header: {
                Text("Password")
            } footer: {
                if let passwordPrompt = viewModel.passwordPrompt {
                    Text(passwordPrompt)
                        .foregroundStyle(Color.red)
                }
            }
            .listSectionSpacing(viewModel.is2FARequired ? .compact : .default)
            
            if viewModel.is2FARequired {
                Section {
                    TextField("2FA Code", text: $viewModel.code2FA)
                        .focused($focusedField, equals: .code2FA)
                        .keyboardType(.default)
                } header: {
                    Text("2FA Code")
                } footer: {
                    if let code2FAPrompt = viewModel.code2FAPrompt {
                        Text(code2FAPrompt)
                            .foregroundStyle(Color.red)
                    }
                }
            }
            
            Section {
                AsyncButton {
                    await viewModel.handleSignInButton()
                } label: {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding(8)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isFormValid)
            } footer: {
                Text("Use your [RevenueCat](https://www.revenuecat.com) account credentials to access. Your credentials are used to create access tokens.\n\nBy proceeding to sign in and using Kedi, you agree to our [Privacy Policy](https://kediapp.com/privacy-policy) and [Terms & Conditions](https://kediapp.com/terms-and-conditions).")
                    .padding()
                    .openUrlInApp()
            }
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Sign In")
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: focusedField) { oldValue, newValue in
            viewModel.onFocusedFieldChange(field: focusedField)
        }
        .alert(
            "Sign In Error",
            isPresented: $viewModel.showingAlert
        ) {
            Button("OK!", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage ?? "An error has occurred.")
        }
    }
}

#Preview {
    SignInScreen()
}
