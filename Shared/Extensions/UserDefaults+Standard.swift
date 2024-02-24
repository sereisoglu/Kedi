//
//  UserDefaults+Standard.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import Foundation

extension UserDefaults {
    
    var overviewConfigs: Data? {
        get {
            data(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var appIcon: String? {
        get {
            string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
