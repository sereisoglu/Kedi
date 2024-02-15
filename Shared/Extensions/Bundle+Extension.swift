//
//  Bundle+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/14/24.
//

import Foundation

extension Bundle {
    
    var versionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
