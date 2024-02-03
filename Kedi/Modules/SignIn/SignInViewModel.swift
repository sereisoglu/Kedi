//
//  SignInViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation
import Combine

final class SignInViewModel: ObservableObject {
    
    enum Field: Hashable {
        case email
        case password
    }
    
    private let apiService = APIService.shared
    private let authManager = AuthManager.shared
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    
    private var cancellableSet = Set<AnyCancellable>()
    private var focusedField: SignInViewModel.Field?
    private var signInError: Error?
    
    @Published private var isEmailValid = false
    @Published private var isEmailFocusedAtLeastOnce = false
    @Published private var isPasswordValid = false
    @Published private var isPasswordFocusedAtLeastOnce = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var isFormValid = false
    
    @Published var showingAlert = false
    
    var emailPrompt: String? {
        (!isEmailValid && focusedField != .email && isEmailFocusedAtLeastOnce) ? "Enter a valid email" : nil
    }
    
    var passwordPrompt: String? {
        (!isPasswordValid && focusedField != .password && isPasswordFocusedAtLeastOnce) ? "Password must be at least 8 characters" : nil
    }
    
    var alertMessage: String? {
        signInError?.localizedDescription
    }
    
    init() {
        $email
            .map { email in
                return self.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellableSet)
        
        $password
            .map { password in
                return password.count >= 8
            }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellableSet)
        
        Publishers.CombineLatest($isEmailValid, $isPasswordValid)
            .map { isEmailValid, isPasswordValid in
                return isEmailValid && isPasswordValid
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellableSet)
    }
    
    @MainActor
    private func signIn(completion: ((Error?) -> Void)? = nil) async {
        do {
            let data = try await apiService.request(
                type: RCLoginModel.self,
                endpoint: .login(email: email, password: password)
            )
            
            if let token = data?.authenticationToken,
               let tokenExpiration = data?.authenticationTokenExpiration {
                authManager.signIn(token: token, tokenExpiration: tokenExpiration)
                
                completion?(nil)
            } else {
                completion?(RCError.nilData)
            }
        } catch {
            completion?(error)
        }
    }
}

// MARK: - Actions

extension SignInViewModel {
    
    func onFocusedFieldChange(field: Field?) {
        focusedField = field
        
        switch field {
        case .email:
            isEmailFocusedAtLeastOnce = true
        case .password:
            isPasswordFocusedAtLeastOnce = true
        case nil:
            return
        }
    }
    
    func handleSignInButton() async {
        await signIn { [weak self] error in
            guard let self else {
                return
            }
            if let error {
                signInError = error
                showingAlert = true
            }
        }
    }
}
