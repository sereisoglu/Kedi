//
//  RCChartRequest.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/9/24.
//

import Foundation

struct RCChartRequest: Encodable {
    
    let resolution: RCChartResolution
    var startDate: String? = nil
    var endDate: String? = nil
    var revenueType: RCChartRevenueType? = nil
    
    enum CodingKeys: String, CodingKey {
        case resolution
        case startDate = "start_date"
        case endDate = "end_date"
        case revenueType = "revenue_type"
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

enum RCChartRevenueType: String, Encodable {
    
    case revenue
    case revenueNetOfTaxes = "revenue_net_of_taxes"
    case proceeds
}
