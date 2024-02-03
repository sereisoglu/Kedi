//
//  SignInView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject private var viewModel = SignInViewModel()
    
    @FocusState private var focusedField: SignInViewModel.Field?
    
    var body: some View {
        NavigationStack {
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
                .listSectionSpacing(0)
                
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
                    Text("Use your RevenueCat account credentials to access. Your RevenueCat account credentials are used to create access tokens.")
                        .padding()
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Sign In")
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: focusedField) { oldValue, newValue in
                viewModel.onFocusedFieldChange(field: focusedField)
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(
                    title: Text("Sign In Error"),
                    message: Text(viewModel.alertMessage ?? "An error has occurred."),
                    dismissButton: .default(Text("OK!"))
                )
            }
        }
    }
}

#Preview {
    SignInView()
}
