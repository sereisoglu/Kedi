//
//  RCProjectsResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/25/24.
//

import Foundation

typealias RCProjectsResponse = [RCProject]

struct RCProject: Decodable {
    
    var iconUrl: String?
    var id: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case iconUrl = "icon_url"
        case id
        case name
    }
}
