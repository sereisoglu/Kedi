//
//  Project.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/25/24.
//

import Foundation

struct Project: Codable, Identifiable, Hashable {
    
    var id: String
    var iconUrl: String?
    var icon: Data?
    var name: String
    var apps: [ProjectApp]?
    var webhookId: String?
}

struct ProjectApp: Codable, Identifiable, Hashable {
    
    var id: String
    var store: String
}
