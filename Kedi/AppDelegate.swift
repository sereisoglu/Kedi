//
//  AppDelegate.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/23/24.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let pushNotificationsManager = PushNotificationsManager.shared
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        pushNotificationsManager.start(launchOptions: launchOptions)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        pushNotificationsManager.updateIconBadgeNumber()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        pushNotificationsManager.updateIconBadgeNumber()
    }
}
