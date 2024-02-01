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
    
    private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    
    private var cancellableSet = Set<AnyCancellable>()
    private var focusedField: SignInViewModel.Field?
    
    @Published private var isEmailValid = false
    @Published private var isEmailFocusedAtLeastOnce = false
    @Published private var isPasswordValid = false
    @Published private var isPasswordFocusedAtLeastOnce = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var isFormValid = false
    
    var emailPrompt: String? {
        (!isEmailValid && focusedField != .email && isEmailFocusedAtLeastOnce) ? "Enter a valid email" : nil
    }
    
    var passwordPrompt: String? {
        (!isPasswordValid && focusedField != .password && isPasswordFocusedAtLeastOnce) ? "Password must be at least 8 characters" : nil
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
    
    func signIn() async {
        do {
            let data = try await APIService.shared.request(type: RCSignInModel.self, endpoint: .login(email: email, password: password))
            print(data)
        } catch {
            print(error)
        }
    }
}
