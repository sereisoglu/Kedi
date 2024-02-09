//
//  RCLoginModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation

struct RCLoginModel: Decodable {
    
    var authenticationToken: String?
    var authenticationTokenExpiration: String?
    var distinctId: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case authenticationToken = "authentication_token"
        case authenticationTokenExpiration = "authentication_token_expiration"
        case distinctId = "distinct_id"
        case email
    }
}
