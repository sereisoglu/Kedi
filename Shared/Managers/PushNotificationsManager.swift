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
    
    @Published private(set) var permissionStatus: PermissionStatus = .disabled
    
    var isPrompted: Bool {
        UserDefaults.standard.isNotificationsPermissionOpened || permissionStatus != .notPrompted
    }
    
    var userId: String? {
        OneSignal.User.onesignalId
    }
    
    static let shared = PushNotificationsManager()
    
    private override init() {}
    
    // MARK: - configure
    
    func start(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.setConsentRequired(true)
        OneSignal.setConsentGiven(true)
        
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        
        OneSignal.initialize("1b5dfd0b-e893-48b4-9f39-ac61653d49f9", withLaunchOptions: launchOptions)
        
        OneSignal.Notifications.addPermissionObserver(self)
        OneSignal.Notifications.addClickListener(self)
        
        permissionStatus = getPermissionStatus()
        
        updateIconBadgeNumber()
    }
    
    // MARK: - attribution
    
    func signIn() {
        OneSignal.login("")
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
    
    func setPermissionStatus() {
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
    }
}

extension PushNotificationsManager: OSNotificationClickListener {
    
    func onClick(event: OSNotificationClickEvent) {
        print("ocClick:", event)
    }
}
