//
//  PushNotificationsManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/23/24.
//

import Foundation
import OneSignalFramework

final class PushNotificationsManager: NSObject, ObservableObject {
    
    enum PermissionStatus {
        
        case notPrompted
        case allowed
        case notAllowed
        case disabled
    }
    
    private var isToggleAllowed = false
    
    @Published private(set) var permissionStatus: PermissionStatus = .notPrompted
    @Published var isNotificationsAllowed: Bool = false {
        didSet {
            if isToggleAllowed {
                togglePermissionStatus()
            }
        }
    }
    
//    var userId: String? {
//        OneSignal.User.onesignalId
//    }
//    
//    var userExternalId: String? {
//        OneSignal.User.externalId
//    }
    
    static let shared = PushNotificationsManager()
    
    private override init() {}
    
    // MARK: - configure
    
    func start(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.setConsentRequired(true)
        OneSignal.setConsentGiven(true)
        
//        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        
        OneSignal.initialize("1b5dfd0b-e893-48b4-9f39-ac61653d49f9", withLaunchOptions: launchOptions)
        
        OneSignal.Notifications.addPermissionObserver(self)
        OneSignal.Notifications.addClickListener(self)
        
        permissionStatus = getPermissionStatus()
        setIsNotificationsAllowed()
        
        updateIconBadgeNumber()
    }
    
    // MARK: - attribution
    
    func signIn(id: String) {
        OneSignal.login(id)
    }
    
    func signOut() {
        OneSignal.logout()
    }
    
    // MARK: - actions
    
    private func getPermissionStatus() -> PermissionStatus {
        if OneSignal.Notifications.canRequestPermission {
            return .notPrompted
        } else {
            if OneSignal.Notifications.permission {
                if OneSignal.User.pushSubscription.optedIn {
                    return .allowed
                } else {
                    return .disabled
                }
            } else {
                return .notAllowed
            }
        }
    }
    
    private func togglePermissionStatus() {
        switch permissionStatus {
        case .notPrompted:
            OneSignal.Notifications.requestPermission { [weak self] accepted in
                self?.permissionStatus = accepted ? .allowed : .notAllowed
            }
            
        case .allowed:
            OneSignal.User.pushSubscription.optOut()
            permissionStatus = .disabled
            
        case .notAllowed:
            BrowserUtility.openSettings()
            
        case .disabled:
            OneSignal.User.pushSubscription.optIn()
            permissionStatus = .allowed
        }
    }
    
    private func setIsNotificationsAllowed() {
        isToggleAllowed = false
        isNotificationsAllowed = permissionStatus == .allowed
        isToggleAllowed = true
    }
    
    func updateIconBadgeNumber() {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().setBadgeCount(notifications.count, withCompletionHandler: nil)
            }
        }
    }
}

extension PushNotificationsManager: OSNotificationPermissionObserver {
    
    func onNotificationPermissionDidChange(_ permission: Bool) {
        if permissionStatus == .disabled {
            OneSignal.User.pushSubscription.optIn()
        }
        permissionStatus = permission ? .allowed : .notAllowed
        setIsNotificationsAllowed()
    }
}

extension PushNotificationsManager: OSNotificationClickListener {
    
    func onClick(event: OSNotificationClickEvent) {
        guard let additionalData = event.notification.additionalData,
              let urlString = additionalData["url"] as? String else {
            return
        }
        BrowserUtility.openUrlOutsideApp(urlString: urlString)
    }
}
