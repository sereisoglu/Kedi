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
    
    var numberOfVisits: Int {
        get {
            register(defaults: [#function: 0])
            return integer(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var isRequestReviewRequested: Bool {
        get {
            register(defaults: [#function: false])
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
