//
//  SettingsViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    
    private let meManager = MeManager.shared
    
    var me: RCMeResponse? { meManager.me }
    var authTokenExpiresDate: Date? { meManager.getAuthTokenExpiresDate() }
}

// MARK: - Actions

extension SettingsViewModel {
    
    @MainActor
    func handleSignOutButton() {
        meManager.signOut()
    }
}
