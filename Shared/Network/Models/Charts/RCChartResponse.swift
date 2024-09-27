//
//  RCChartResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

// FIXME: Make documentationLink dynamic

struct RCChartResponse: Decodable {
    
    var name: RCChartName? { documentationLink?.name }
    
    var documentationLink: RCChartDocumentationLink?
    var lastComputedAt: String?
    var segments: [RCChartSegment]?
    var summary: [String: [String: Double]]?
    var incompletePeriods: [[Bool]]?
    var values: [[Double]]?
    
    enum CodingKeys: String, CodingKey {
        case documentationLink = "documentation_link"
        case lastComputedAt = "last_computed_at"
        case segments
        case summary
        case incompletePeriods = "incomplete_periods"
        case values
    }
}

enum RCChartDocumentationLink: String, Decodable {
    
    case actives = "dashboard-and-metrics/charts/active-subscriptions-chart"
    case activesMovement = "dashboard-and-metrics/charts/active-subscriptions-movement-chart"
    case arr = "dashboard-and-metrics/charts/annual-recurring-revenue-arr-chart"
    case churn = "dashboard-and-metrics/charts/churn-chart"
    case conversionToPaying = "dashboard-and-metrics/charts/conversion-to-paying-chart"
    case initialConversion = "dashboard-and-metrics/charts/initial-conversion-chart"
    case ltvPerCustomer = "dashboard-and-metrics/charts/realized-ltv-per-customer-chart"
    case ltvPerPayingCustomer = "dashboard-and-metrics/charts/realized-ltv-per-paying-customer-chart"
    case mrr = "dashboard-and-metrics/charts/monthly-recurring-revenue-mrr-chart"
    case mrrMovement = "dashboard-and-metrics/charts/monthly-recurring-revenue-movement-chart"
    case refundRate = "dashboard-and-metrics/charts/refund-rate-chart"
    case revenue = "dashboard-and-metrics/charts/revenue-chart"
//    case subscriptionRetention = "dashboard-and-metrics/charts/subscription-retention-chart"
    case trialConversion = "dashboard-and-metrics/charts/trial-conversion-chart"
    case trials = "dashboard-and-metrics/charts/active-trials-chart"
    case trialsMovement = "dashboard-and-metrics/charts/active-trials-movement-chart"
    
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

struct RCChartSegment: Decodable {
    
    var chartable: Bool?
    var description: String?
    var displayName: String?
    var tabulable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case chartable
        case description
        case displayName = "display_name"
        case tabulable
    }
}
