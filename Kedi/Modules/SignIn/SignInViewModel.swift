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
    private let authManager = AuthManager.shared
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    
    private var cancellableSet = Set<AnyCancellable>()
    private var focusedField: SignInViewModel.Field?
    private var signInError: RCError?
    
    @Published private var isEmailValid = false
    @Published private var isEmailFocusedAtLeastOnce = false
    @Published private var isPasswordValid = false
    @Published private var isPasswordFocusedAtLeastOnce = false
    @Published private var isCode2FAValid = false
    @Published private var isCode2FAFocusedAtLeastOnce = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var code2FA = ""
    @Published var is2FARequired = false
    @Published var isFormValid = false
    
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
        signInError?.message
    }
    
    init() {
        $email
            .map { email in
                self.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellableSet)
        
        $password
            .map { password in
                password.count >= 8
            }
            .assign(to: \.isPasswordValid, on: self)
            .store(in: &cancellableSet)
        
        $code2FA
            .map { code2FA in
                !code2FA.isEmpty
            }
            .assign(to: \.isCode2FAValid, on: self)
            .store(in: &cancellableSet)
        
        setPublishers()
    }
    
    private func setPublishers() {
        if is2FARequired {
            Publishers.CombineLatest3($isEmailValid, $isPasswordValid, $isCode2FAValid)
                .map { $0 && $1 && $2 }
                .assign(to: \.isFormValid, on: self)
                .store(in: &cancellableSet)
        } else {
            Publishers.CombineLatest($isEmailValid, $isPasswordValid)
                .map { $0 && $1 }
                .assign(to: \.isFormValid, on: self)
                .store(in: &cancellableSet)
        }
    }
    
    @MainActor
    private func postSignIn(completion: ((Error?) -> Void)? = nil) async {
        do {
            let request: RCLoginRequest
            if is2FARequired {
                request = .init(email: email, password: password, otpCode: code2FA)
            } else {
                request = .init(email: email, password: password)
            }
            
            let data = try await apiService.request(
                type: RCLoginResponse.self,
                endpoint: .login(request)
            )
            
            if let token = data?.authenticationToken,
               let tokenExpiration = data?.authenticationTokenExpiration {
                authManager.signIn(token: token, tokenExpiration: tokenExpiration)
                
                completion?(nil)
            } else {
                completion?(RCError.internal(.nilResponse))
            }
        } catch RCError.oneTimePasswordNeeded {
            is2FARequired = true
            setPublishers()
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
        case .code2FA:
            isCode2FAFocusedAtLeastOnce = true
        case nil:
            return
        }
    }
    
    func handleSignInButton() async {
        await postSignIn { [weak self] error in
            guard let self else {
                return
            }
            if let error = error as? RCError {
                signInError = error
                showingAlert = true
            }
        }
    }
}
