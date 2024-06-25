//
//  KediApp.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import SwiftUI

@main
struct KediApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        PurchaseManager.shared.start()
        AnalyticsManager.shared.start()
        SessionManager.shared.start()
        
        AnalyticsManager.shared.send(event: .`init`)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(MeManager.shared)
                .environmentObject(PurchaseManager.shared)
                .environmentObject(PushNotificationsManager.shared)
                .environmentObject(UserDefaultsManager.shared)
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        }
    }
}
