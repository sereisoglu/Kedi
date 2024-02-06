//
//  RCChartName.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

enum RCChartName: String, CaseIterable {
    
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
