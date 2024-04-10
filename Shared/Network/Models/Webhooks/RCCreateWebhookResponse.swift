//
//  RCCreateWebhookResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/6/24.
//

import Foundation

struct RCCreateWebhookResponse: Decodable {
    
    var id: String?
    var projectId: String?
    var name: String?
    var url: String?
    var authorizationHeader: String?
    var environment: String?
    var appId: String?
    var eventTypes: [String]?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case name
        case url
        case authorizationHeader = "authorization_header"
        case environment
        case appId = "app_id"
        case eventTypes = "event_types"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
