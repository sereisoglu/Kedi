//
//  UserDefaultsManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/25/24.
//

import Foundation

final class UserDefaultsManager: ObservableObject {
    
    private let userDefaults = UserDefaults.standard
    
    @Published var isRequestReviewClosed = false {
        didSet {
            userDefaults.isRequestReviewClosed = isRequestReviewClosed
        }
    }
    
    @Published var isOnboardingOpened = false {
        didSet {
            userDefaults.isOnboardingOpened = isOnboardingOpened
        }
    }
    
    static let shared = UserDefaultsManager()
    
    private init() {
        isRequestReviewClosed = userDefaults.isRequestReviewClosed
        isOnboardingOpened = userDefaults.isOnboardingOpened
    }
}
