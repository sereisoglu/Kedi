//
//  SettingsView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                AsyncButton {
                    viewModel.handleSignOutButton()
                } label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
