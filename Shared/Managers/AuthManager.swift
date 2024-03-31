//
//  AuthManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/30/24.
//

import Foundation

final class AuthManager: ObservableObject {
    
    private let keychainManager = KeychainManager.shared
    private let sessionManager = SessionManager.shared
    
    @Published private(set) var isSignedIn: Bool = false
    
    static let shared = AuthManager()
    
    private init() {}
    
    @MainActor
    func setIsSignedIn(_ value: Bool) {
        isSignedIn = value
    }
    
    // Auth Token
    
    func getAuthToken() -> String? {
        getAuthTokenFromKeychain() ?? getAuthTokenFromSession()
    }
    
    private func getAuthTokenFromKeychain() -> String? {
        guard let token = keychainManager.get(.rcAuthToken),
              let tokenExpiresAt = Int(keychainManager.get(.rcAuthTokenExpiresAt) ?? "") else {
            return nil
        }
        let isExpired = Int(Date().timeIntervalSince1970) > tokenExpiresAt
        return isExpired ? nil : token
    }
    
    private func getAuthTokenFromSession() -> String? {
        guard let cookie = sessionManager.getRevenueCatCookie() else {
            return nil
        }
        let isExpired = Date.now > (cookie.expiresDate ?? .now)
        return isExpired ? nil : cookie.value
    }
    
    // Auth Token Expires Date
    
    func getAuthTokenExpiresDate() -> Date? {
        getAuthTokenExpiresDateFromKeychain() ?? getAuthTokenExpiresDateFromSession()
    }
    
    private func getAuthTokenExpiresDateFromKeychain() -> Date? {
        guard let rcAuthTokenExpiresAt = keychainManager.get(.rcAuthTokenExpiresAt),
              let tokenExpiresAt = TimeInterval(rcAuthTokenExpiresAt) else {
            return nil
        }
        return .init(timeIntervalSince1970: tokenExpiresAt)
    }
    
    private func getAuthTokenExpiresDateFromSession() -> Date? {
        sessionManager.getRevenueCatCookie()?.expiresDate
    }
}
