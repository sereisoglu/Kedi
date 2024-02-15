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
        case code2FA
    }
    
    private let apiService = APIService.shared
    private let meManager = MeManager.shared
    
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    
    private var cancellableFields = Set<AnyCancellable>()
    private var cancellableFormValid: AnyCancellable?
    private var focusedField: SignInViewModel.Field?
    private var signInError: Error?
    
    @Published private var isEmailValid = false
    @Published private var isEmailFocusedAtLeastOnce = false
    @Published private var isPasswordValid = false
    @Published private var isPasswordFocusedAtLeastOnce = false
    @Published private var isCode2FAValid = false
    @Published private var isCode2FAFocusedAtLeastOnce = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var code2FA = ""
    @Published private(set) var is2FARequired = false
    @Published private(set) var isFormValid = false
    
    @Published var showingAlert = false
    
    var emailPrompt: String? {
        (!isEmailValid && focusedField != .email && isEmailFocusedAtLeastOnce) ? "Enter a valid email" : nil
    }
    
    var passwordPrompt: String? {
        (!isPasswordValid && focusedField != .password && isPasswordFocusedAtLeastOnce) ? "Password must be at least 8 characters" : nil
    }
    
    var code2FAPrompt: String? {
        (!isCode2FAValid && focusedField != .code2FA && isCode2FAFocusedAtLeastOnce) ? "2FA Code cannot be empty" : nil
    }
    
    var alertMessage: String? {
        signInError?.localizedDescription
    }
    
    init() {
        $email
            .map { email in
                self.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellableFields)
        
        $password
            .map { password in
                password.count >= 8
            }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellableFields)
        
        $code2FA
            .map { code2FA in
                !code2FA.isEmpty
            }
            .assign(to: \.isCode2FAValid, on: self)
            .store(in: &cancellableFields)
        
        setPublishers()
    }
    
    private func setPublishers() {
        if is2FARequired {
            cancellableFormValid = Publishers.CombineLatest3($isEmailValid, $isPasswordValid, $isCode2FAValid)
                .map { $0 && $1 && $2 }
                .assign(to: \.isFormValid, on: self)
        } else {
            cancellableFormValid = Publishers.CombineLatest($isEmailValid, $isPasswordValid)
                .map { $0 && $1 }
                .assign(to: \.isFormValid, on: self)
        }
    }
    
    @MainActor
    private func postSignIn() async throws {
        do {
            let loginData = try await apiService.request(
                type: RCLoginResponse.self,
                endpoint: .login(.init(
                    email: email,
                    password: password,
                    otpCode: is2FARequired ? code2FA : nil
                ))
            )
            
            if let token = loginData?.authenticationToken,
               let tokenExpiration = loginData?.authenticationTokenExpiration {
                let isSignedIn = meManager.signIn(token: token, tokenExpiration: tokenExpiration)
                
                if !isSignedIn {
                    throw RCError.internal(.nilResponse)
                }
            } else {
                throw RCError.internal(.nilResponse)
            }
        } catch RCError.oneTimePasswordNeeded {
            is2FARequired = true
            setPublishers()
        } catch {
            throw error
        }
    }
}

// MARK: - Actions

extension SignInViewModel {
    
    @MainActor
    func onFocusedFieldChange(field: Field?) {
        focusedField = field
        
        switch field {
        case .email:
            isEmailFocusedAtLeastOnce = true
        case .password:
            isPasswordFocusedAtLeastOnce = true
        case .code2FA:
            isCode2FAFocusedAtLeastOnce = true
        case nil:
            return
        }
    }
    
    @MainActor
    func handleSignInButton() async {
        do {
            try await postSignIn()
        } catch {
            signInError = error
            showingAlert = true
        }
    }
}
