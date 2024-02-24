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
    private let cacheManager = CacheManager.shared
    private let widgetsManager = WidgetsManager.shared
    
    private(set) var me: RCMeResponse?
    private(set) var firstTransactionDate: Date?
    @Published private(set) var isSignedIn: Bool = false
    
    static let shared = MeManager()
    
    private init() {
        let authToken = getAuthToken()
        
        apiService.setAuthToken(authToken)
        me = cacheManager.getWithDecode(key: "me", type: RCMeResponse.self)
        firstTransactionDate = me?.firstTransactionAt?.format(to: .iso8601WithoutMilliseconds)
        
        isSignedIn = authToken != nil
    }
    
    func getAuthToken() -> String? {
        guard let token = keychainManager.get(.rcAuthToken),
              let tokenExpiresAt = Int(keychainManager.get(.rcAuthTokenExpiresAt) ?? "") else {
            return nil
        }
        
        let isExpired = Int(Date().timeIntervalSince1970) > tokenExpiresAt
        
        if isExpired {
            signOut()
            return nil
        } else {
            return token
        }
    }
    
    func getAuthTokenExpiresDate() -> Date? {
        guard let tokenExpiresAt = Int(keychainManager.get(.rcAuthTokenExpiresAt) ?? "") else {
            return nil
        }
        
        return .init(timeIntervalSince1970: TimeInterval(tokenExpiresAt))
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
        apiService.setAuthToken(token)
        widgetsManager.reloadAll()
        isSignedIn = true
        SessionManager.shared.start()
        
        return true
    }
    
    func set(me: RCMeResponse?) {
        self.me = me
        firstTransactionDate = me?.firstTransactionAt?.format(to: .iso8601WithoutMilliseconds)
        
        cacheManager.setWithEncode(key: "me", data: me, expiry: .never)
    }
    
    func signOut() {
        cacheManager.remove(key: "me")
        keychainManager.delete(.rcAuthToken)
        keychainManager.delete(.rcAuthTokenExpiresAt)
        apiService.setAuthToken(nil)
        widgetsManager.reloadAll()
        isSignedIn = false
    }
}
