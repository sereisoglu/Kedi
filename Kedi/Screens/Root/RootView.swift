//
//  RootView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var meManager: MeManager
    
    var body: some View {
        if meManager.isSignedIn {
            MainView()
        } else {
            NavigationStack {
                SignInView()
            }
        }
    }
}

#Preview {
    RootView()
}
