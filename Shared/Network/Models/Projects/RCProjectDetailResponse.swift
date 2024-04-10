//
//  RCProjectDetailResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/8/24.
//

import Foundation

struct RCProjectDetailResponse: Decodable {
    
    var iconUrl: String?
    var id: String?
    var name: String?
    var apps: [RCProjectDetailApp]?
    
    enum CodingKeys: String, CodingKey {
        case iconUrl = "icon_url"
        case id
        case name
        case apps
    }
}

struct RCProjectDetailApp: Decodable {
    
    var id: String?
    var type: String?
}
