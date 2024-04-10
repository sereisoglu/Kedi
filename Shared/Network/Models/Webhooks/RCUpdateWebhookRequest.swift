//
//  RCUpdateWebhookRequest.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/5/24.
//

import Foundation

struct RCUpdateWebhookRequest: Encodable {
    
    var name: String?
    var url: String?
    var authorizationHeader: String?
    var environment: String?
    var appId: String?
    var eventTypes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case authorizationHeader = "authorization_header"
        case environment
        case appId = "app_id"
        case eventTypes = "event_types"
    }
}
