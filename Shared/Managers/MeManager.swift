//
//  MeManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

final class MeManager: ObservableObject {
    
    private let apiService = APIService.shared
    private let authManager = AuthManager.shared
    private let keychainManager = KeychainManager.shared
    private let sessionManager = SessionManager.shared
    private let cacheManager = CacheManager.shared
    private let widgetsManager = WidgetsManager.shared
    private let purchaseManager = PurchaseManager.shared
    private let pushNotificationsManager = PushNotificationsManager.shared
    
    @Published private(set) var isSignedIn: Bool = false
    
    private(set) var id: String?
    private(set) var me: RCMeResponse?
    private(set) var projects: [Project]?
    
    static let shared = MeManager()
    
    private init() {
        id = keychainManager.get(.id)
        if id == nil {
            generateId()
        }
        
        guard let id,
              let authToken = authManager.getAuthToken() else {
            signOut()
            return
        }
        
        me = cacheManager.getWithDecode(key: "me", type: RCMeResponse.self)
        projects = cacheManager.getWithDecode(key: "projects", type: [Project].self)
        
        apiService.setAuthToken(authToken)
        Task {
            try? await purchaseManager.signIn(id: id)
        }
        pushNotificationsManager.signIn(id: id)
        isSignedIn = true
    }
    
    @discardableResult
    func signIn(
        token: String,
        tokenExpiration: String
    ) -> Bool {
        guard let id,
              let tokenExpirationDate = tokenExpiration.format(to: .iso8601WithoutMilliseconds) else {
            return false
        }
        keychainManager.set(token, forKey: .rcAuthToken)
        keychainManager.set("\(Int(tokenExpirationDate.timeIntervalSince1970))", forKey: .rcAuthTokenExpiresAt)
        sessionManager.start()
        apiService.setAuthToken(token)
        widgetsManager.reloadAll()
        Task {
            try? await purchaseManager.signIn(id: id)
        }
        pushNotificationsManager.signIn(id: id)
        isSignedIn = true
        return true
    }
    
    func signOut() {
        keychainManager.delete(.rcAuthToken)
        keychainManager.delete(.rcAuthTokenExpiresAt)
        sessionManager.removeCookies()
        apiService.setAuthToken(nil)
        cacheManager.remove(key: "me")
        cacheManager.remove(key: "projects")
        widgetsManager.reloadAll()
        Task {
            try? await purchaseManager.signOut()
        }
        pushNotificationsManager.signOut()
        isSignedIn = false
    }
    
    func generateId() {
        let hasId = id != nil
        
        id = UUID().uuidString
        keychainManager.set(id ?? "", forKey: .id)
        
        if hasId,
           let id {
            Task {
                try? await purchaseManager.signIn(id: id)
            }
            pushNotificationsManager.signIn(id: id)
        }
    }
    
    func set(me: RCMeResponse?, projects: [Project]?) {
        self.me = me
        self.projects = projects
        cacheManager.setWithEncode(key: "me", data: me, expiry: .never)
        cacheManager.setWithEncode(key: "projects", data: projects, expiry: .never)
    }
    
    func getProject(appId: String) -> Project? {
        projects?.first(where: { $0.apps?.contains(where: { $0.id == id }) ?? false })
    }
}
