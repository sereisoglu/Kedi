//
//  KediApp.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import SwiftUI

@main
struct KediApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AuthManager.shared)
        }
    }
}
