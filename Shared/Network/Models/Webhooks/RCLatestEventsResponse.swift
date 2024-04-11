//
//  RCLatestEventsResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/11/24.
//

import Foundation

struct RCLatestEventsResponse: Decodable {
    
    var events: [RCEvent]?
    
    enum CodingKeys: String, CodingKey {
        case events = "last_events"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eventBodies = try container.decodeIfPresent([RCEventBody].self, forKey: .events)
        events = eventBodies?.compactMap(\.event)
    }
}

struct RCEventBody: Decodable {
    
    var event: RCEvent?
    
    enum CodingKeys: String, CodingKey {
        case requestBody = "request_body"
    }
    
    enum RequestBodyCodingKeys: String, CodingKey {
        case event
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let requestBodyContainer = try container.nestedContainer(keyedBy: RequestBodyCodingKeys.self, forKey: .requestBody)
        event = try requestBodyContainer.decodeIfPresent(RCEvent.self, forKey: .event)
    }
}
