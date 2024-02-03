//
//  AuthManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

final class AuthManager: ObservableObject {
    
    private let apiService = APIService.shared
    private let keychainManager = KeychainManager.shared
    
    @Published var isSignedIn: Bool = false
    
    static let shared = AuthManager()
    
    private init() {
        let authToken = getAuthToken()
        
        apiService.setAuthToken(authToken)
        isSignedIn = authToken != nil
    }
    
    func getAuthToken() -> String? {
        let token = KeychainManager.shared.get(.rcAuthToken)
        let tokenExpiresAt = Int(KeychainManager.shared.get(.rcAuthTokenExpiresAt) ?? "") ?? 0
        
        let isExpired = Int(Date().timeIntervalSince1970) > tokenExpiresAt
        
        if isExpired {
            signOut()
            return nil
        } else {
            return token
        }
    }
    
    func signIn(
        token: String,
        tokenExpiration: String
    ) {
        guard let date = DateFormatter.iso8601WithoutMilliseconds.date(from: tokenExpiration) else {
            return
        }
        
        keychainManager.set(token, forKey: .rcAuthToken)
        keychainManager.set("\(Int(date.timeIntervalSince1970))", forKey: .rcAuthTokenExpiresAt)
        apiService.setAuthToken(token)
        isSignedIn = true
    }
    
    func signOut() {
        keychainManager.delete(.rcAuthToken)
        keychainManager.delete(.rcAuthTokenExpiresAt)
        apiService.setAuthToken(nil)
        isSignedIn = false
    }
}
