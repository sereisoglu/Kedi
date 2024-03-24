//
//  AppDelegate.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/23/24.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        PushNotificationsManager.shared.start(launchOptions: launchOptions)
        
//       // Remove this method to stop OneSignal Debugging
//       OneSignal.Debug.setLogLevel(.LL_VERBOSE)
//
//       // OneSignal initialization
//       OneSignal.initialize("YOUR_ONESIGNAL_APP_ID", withLaunchOptions: launchOptions)
//
//       // requestPermission will show the native iOS notification permission prompt.
//       // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//       OneSignal.Notifications.requestPermission({ accepted in
//         print("User accepted notifications: \(accepted)")
//       }, fallbackToSettings: true)
//
//       // Login your customer with externalId
//       // OneSignal.login("EXTERNAL_ID")
            
       return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        PushNotificationsManager.shared.updateIconBadgeNumber()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        PushNotificationsManager.shared.updateIconBadgeNumber()
    }
}
