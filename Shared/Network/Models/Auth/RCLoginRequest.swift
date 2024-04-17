//
//  RCLoginRequest.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/9/24.
//

import Foundation

struct RCLoginRequest: Encodable {
    
    let email: String
    let password: String
    var otpCode: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case otpCode = "otp_code"
    }
}
