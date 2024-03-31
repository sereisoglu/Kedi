//
//  Project.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/25/24.
//

import Foundation

struct Project: Codable {
    
    var iconUrl: String?
    var icon: Data?
    var projectId: String
    var appId: String
    var name: String
}
