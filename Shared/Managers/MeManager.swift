//
//  MeManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

final class MeManager: ObservableObject {
    
    private let apiService = APIService.shared
    private let keychainManager = KeychainManager.shared
    private let sessionManager = SessionManager.shared
    private let cacheManager = CacheManager.shared
    private let widgetsManager = WidgetsManager.shared
    
    private(set) var me: RCMeResponse?
    @Published private(set) var isSignedIn: Bool = false
    
    static let shared = MeManager()
    
    private init() {
        let authToken = getAuthToken()
        
        apiService.setAuthToken(authToken)
        me = cacheManager.getWithDecode(key: "me", type: RCMeResponse.self)
        
        isSignedIn = authToken != nil
    }
    
    func getAuthToken() -> String? {
        let token = getAuthTokenFromKeychain() ?? getAuthTokenFromSession()
        if token == nil {
            signOut()
        }
        return token
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
    
    @discardableResult
    func signIn(
        token: String,
        tokenExpiration: String
    ) -> Bool {
        guard let tokenExpirationDate = tokenExpiration.format(to: .iso8601WithoutMilliseconds) else {
            return false
        }
        keychainManager.set(token, forKey: .rcAuthToken)
        keychainManager.set("\(Int(tokenExpirationDate.timeIntervalSince1970))", forKey: .rcAuthTokenExpiresAt)
        sessionManager.start()
        apiService.setAuthToken(token)
        widgetsManager.reloadAll()
        isSignedIn = true
        return true
    }
    
    func set(me: RCMeResponse?) {
        self.me = me
        cacheManager.setWithEncode(key: "me", data: me, expiry: .never)
    }
    
    func signOut() {
        keychainManager.delete(.rcAuthToken)
        keychainManager.delete(.rcAuthTokenExpiresAt)
        sessionManager.removeCookies()
        cacheManager.remove(key: "me")
        apiService.setAuthToken(nil)
        widgetsManager.reloadAll()
        isSignedIn = false
    }
}
