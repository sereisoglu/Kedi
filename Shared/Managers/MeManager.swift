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
    private let analyticsManager = AnalyticsManager.shared
    
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
        if let id = me?.distinctId {
            Task {
                try? await purchaseManager.signIn(id: id)
            }
        }
        pushNotificationsManager.signIn(id: id)
        analyticsManager.signIn(id: me?.distinctId)
        purchaseManager.setKid(id)
        isSignedIn = true
        
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            forName: .apiServiceRequestError,
            object: nil,
            queue: .main,
            using: { [weak self] notification in
                guard let self,
                      let error = notification.object as? RCError else {
                    return
                }
                
                switch error {
                case .invalidAuthorizationToken,
                        .expiredAuthorizationToken:
                    self.signOut()
                default:
                    return
                }
            }
        )
    }
    
    @discardableResult
    func signIn(data: RCLoginResponse?) -> Bool {
        guard let id,
              let token = data?.authenticationToken,
              let tokenExpiration = data?.authenticationTokenExpiration,
              let tokenExpirationDate = tokenExpiration.format(to: .iso8601WithoutMilliseconds) else {
            return false
        }
        keychainManager.set(token, forKey: .rcAuthToken)
        keychainManager.set("\(Int(tokenExpirationDate.timeIntervalSince1970))", forKey: .rcAuthTokenExpiresAt)
        sessionManager.start()
        apiService.setAuthToken(token)
        widgetsManager.reloadAll()
        if let id = data?.distinctId {
            Task {
                try? await purchaseManager.signIn(id: id)
            }
        }
        pushNotificationsManager.signIn(id: id)
        analyticsManager.signIn(id: data?.distinctId)
        purchaseManager.setKid(id)
        purchaseManager.setOneSignalId(pushNotificationsManager.userId)
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
        analyticsManager.signOut()
        isSignedIn = false
    }
    
    // MARK: - id
    
    func generateId() {
        let hasId = id != nil
        
        id = UUID().uuidString
        keychainManager.set(id ?? "", forKey: .id)
        
        if hasId,
           let id {
            purchaseManager.setKid(id)
            pushNotificationsManager.signIn(id: id)
        }
    }
    
    // MARK: - me, projects
    
    func set(me: RCMeResponse?) {
        self.me = me
        cacheManager.setWithEncode(key: "me", data: me, expiry: .never)
    }
    
    func set(projects: [Project]?) {
        guard self.projects != projects else {
            return
        }
        self.projects = projects
        cacheManager.setWithEncode(key: "projects", data: projects, expiry: .never)
    }
    
    func getProject(appId: String) -> Project? {
        projects?.first(where: { $0.apps?.contains(where: { $0.id == appId }) ?? false })
    }
}
