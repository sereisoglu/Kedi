//
//  RCMeResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

struct RCMeResponse: Codable {
    
    var distinctId: String?
    var email: String?
    var name: String?
    var firstTransactionAt: String?
    var currentPlan: String?
    var billingInfo: RCMeBillingInfo?
    var apps: [RCMeApp]?
    
    enum CodingKeys: String, CodingKey {
        case distinctId = "distinct_id"
        case email
        case name
        case firstTransactionAt = "first_transaction_at"
        case currentPlan = "current_plan"
        case billingInfo = "billing_info"
        case apps
    }
}

struct RCMeBillingInfo: Codable {
    
    var currentMtr: Int?
    var trailing30dayMtr: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentMtr = "current_mtr"
        case trailing30dayMtr = "trailing_30day_mtr"
    }
}

struct RCMeApp: Codable {
    
    var id: String?
    var name: String?
}

extension RCMeResponse {
    
    static let stub: Self = {
        let string = #"""
        {
            "apps": [
                {
                    "bundle_id": "com.sereisoglu.kedi",
                    "id": "app001",
                    "name": "Kedi",
                }
            ],
            "billing_info": {
                "current_mtr": 2345,
                "trailing_30day_mtr": 5677
            },
            "current_plan": "starter",
            "distinct_id": "RC0123456789",
            "email": "support@kediapp.com",
            "first_transaction_at": "2024-02-15T00:00:00Z",
            "name": "Saffet Emin Reisoğlu",
        }
        """#
        return try! JSONDecoder().decode(Self.self, from: .init(string.utf8))
    }()
}
