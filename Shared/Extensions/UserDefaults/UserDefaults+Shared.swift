//
//  UserDefaults+Shared.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import Foundation

extension UserDefaults {
    
    static var shared: UserDefaults {
        .init(suiteName: "group.com.sereisoglu.kedi") ?? .standard
    }
}
