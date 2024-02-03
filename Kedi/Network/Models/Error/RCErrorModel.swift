//
//  RCErrorModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation

struct RCErrorModel: Decodable {
    
    var code: Int?
    var message: String?
}

// {"code":7002,"message":"Invalid e-mail or password."}
// { "code": 7224, "message": "Invalid authorization token." }
