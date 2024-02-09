//
//  RCTransactionsRequest.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/9/24.
//

import Foundation

struct RCTransactionsRequest: Encodable {
    
    var sandboxMode = false
    var limit = 100
    var endDate: String?
    
    enum CodingKeys: String, CodingKey {
        case sandboxMode = "sandbox_mode"
        case limit
        case endDate = "end_date"
    }
}
