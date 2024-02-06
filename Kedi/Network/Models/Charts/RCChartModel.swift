//
//  RCChartModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

typealias RCChartValue = [Double]

struct RCChartModel: Decodable {
    
    var name: RCChartName? { documentationLink?.name }
    
    var documentationLink: RCChartDocumentationLink?
    var values: [RCChartValue]?
    var summary: [String : [String: Double]]?
    
    enum CodingKeys: String, CodingKey {
        case documentationLink = "documentation_link"
        case values = "values"
        case summary
    }
}

enum RCChartDocumentationLink: String, Decodable {
    
    case actives = "active-subscriptions-chart"
    case activesMovement = "active-subscriptions-movement-chart"
    case arr = "annual-recurring-revenue-arr-chart"
    case churn = "churn-chart"
    case conversionToPaying = "conversion-to-paying-chart"
    case initialConversion = "initial-conversion-chart"
    case ltvPerCustomer = "realized-ltv-per-customer-chart"
    case ltvPerPayingCustomer = "realized-ltv-per-paying-customer-chart"
    case mrr = "monthly-recurring-revenue-mrr-chart"
    case mrrMovement = "monthly-recurring-revenue-movement-chart"
    case refundRate = "refund-rate-chart"
    case revenue = "revenue-chart"
//    case subscriptionRetention = "subscription-retention-chart"
    case trialConversion = "trial-conversion-chart"
    case trials = "active-trials-chart"
    case trialsMovement = "active-trials-movement-chart"
    
    var name: RCChartName {
        switch self {
        case .actives: .actives
        case .activesMovement: .activesMovement
        case .arr: .arr
        case .churn: .churn
        case .conversionToPaying: .conversionToPaying
        case .initialConversion: .initialConversion
        case .ltvPerCustomer: .ltvPerCustomer
        case .ltvPerPayingCustomer: .ltvPerPayingCustomer
        case .mrr: .mrr
        case .mrrMovement: .mrrMovement
        case .refundRate: .refundRate
        case .revenue: .revenue
//        case .subscriptionRetention: .subscriptionRetention
        case .trialConversion: .trialConversion
        case .trials: .trials
        case .trialsMovement: .trialsMovement
        }
    }
}
