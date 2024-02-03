//
//  SettingsViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    
    private let authManager = AuthManager.shared
}

// MARK: - Actions

extension SettingsViewModel {
    
    @MainActor
    func handleSignOutButton() {
        authManager.signOut()
    }
}
