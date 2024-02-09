//
//  RCChartRequest.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/9/24.
//

import Foundation

struct RCChartRequest: Encodable {
    
    let name: RCChartName
    let resolution: RCChartResolution
    var startDate: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case name
        case resolution
        case startDate = "start_date"
    }
}

enum RCChartName: String, CaseIterable, Encodable {
    
    case actives
    case activesMovement = "actives_movement"
    case arr
    case churn
    case conversionToPaying = "conversion_to_paying"
    case initialConversion = "initial_conversion"
    case ltvPerCustomer = "ltv_per_customer"
    case ltvPerPayingCustomer = "ltv_per_paying_customer"
    case mrr
    case mrrMovement = "mrr_movement"
    case refundRate = "refund_rate"
    case revenue
//    case subscriptionRetention = "subscription_retention"
    case trialConversion = "trial_conversion"
    case trials
    case trialsMovement = "trials_movement"
}

enum RCChartResolution: Int, Encodable {
    
    case day
    case week
    case month
    case quarter
    case year
}
