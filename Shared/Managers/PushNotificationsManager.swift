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
    @Published var isAllowed = false {
        didSet {
            if isToggleAllowed {
                togglePermissionStatus(completion: nil)
            }
        }
    }
    @Published var isPermissionOpened = false {
        didSet {
            UserDefaults.standard.isNotificationsPermissionOpened = isPermissionOpened
        }
    }
    
    var userId: String? {
        OneSignal.User.onesignalId
    }
    
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
        
        OneSignal.initialize(EnvVars.oneSignal, withLaunchOptions: launchOptions)
        
        OneSignal.Notifications.addPermissionObserver(self)
        OneSignal.Notifications.addClickListener(self)
        
        permissionStatus = getPermissionStatus()
        setIsAllowed()
        isPermissionOpened = (
            UserDefaults.standard.isNotificationsPermissionOpened ||
            permissionStatus != .notPrompted
        )
        
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
    
    func togglePermissionStatus(completion: ((PermissionStatus) -> Void)?) {
        switch permissionStatus {
        case .notPrompted:
            OneSignal.Notifications.requestPermission { [weak self] accepted in
                guard let self else {
                    return
                }
                self.permissionStatus = accepted ? .allowed : .notAllowed
                completion?(self.permissionStatus)
            }
            
        case .allowed:
            OneSignal.User.pushSubscription.optOut()
            permissionStatus = .disabled
            completion?(permissionStatus)
            
        case .notAllowed:
            BrowserUtility.openSettings()
            
        case .disabled:
            OneSignal.User.pushSubscription.optIn()
            permissionStatus = .allowed
            completion?(permissionStatus)
        }
    }
    
    private func setIsAllowed() {
        isToggleAllowed = false
        isAllowed = permissionStatus == .allowed
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
        setIsAllowed()
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
