//
//  RCErrorResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation

struct RCErrorResponse: Decodable {
    
    var code: Int?
    var message: String?
}

// { "code": 7002, "message": "Invalid e-mail or password." }
// { "code": 7224, "message": "Invalid authorization token." }
// { "code": 7667, "message": "Expired authorization token." }
// { "code": 7008, "message": "One time password needed." }
// { "code": 7632, "message": "invalid X-Requested-With header value" }
// { "code": 7011, "message": "Invalid One time password." }
// { "code": 7114, "message": "Too many requests." }
