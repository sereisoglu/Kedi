//
//  KediApp.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import SwiftUI

@main
struct KediApp: App {
    
    init() {
        PurchaseManager.shared.start()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(MeManager.shared)
                .dynamicTypeSize(DynamicTypeSize.medium...DynamicTypeSize.xxxLarge)
        }
    }
}
