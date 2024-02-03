//
//  RootView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isSignedIn {
            MainView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    RootView()
}
