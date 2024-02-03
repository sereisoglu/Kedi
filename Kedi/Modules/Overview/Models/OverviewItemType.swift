//
//  OverviewItemType.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

enum OverviewItemType {
    
    case mrr
    case subsciptions
    case trials
    case revenue
    case users
    case installs
    case arr
    case revenueAllTime
    
    var icon: String {
        switch self {
        case .mrr: "dollarsign.arrow.circlepath"
        case .subsciptions: "repeat"
        case .trials: "clock"
        case .revenue: "dollarsign"
        case .users: "person.2"
        case .installs: "iphone"
        case .arr: "dollarsign.arrow.circlepath"
        case .revenueAllTime: "dollarsign"
        }
    }
    
    var name: String {
        switch self {
        case .mrr: "MRR"
        case .subsciptions: "Subsciptions"
        case .trials: "Trials"
        case .revenue: "Revenue"
        case .users: "Users"
        case .installs: "Installs"
        case .arr: "ARR"
        case .revenueAllTime: "Revenue"
        }
    }
    
    var note: String? {
        switch self {
        case .mrr: nil
        case .subsciptions: nil
        case .trials: nil
        case .revenue: "Last 28 days"
        case .users: "Last 28 days"
        case .installs: "Last 28 days"
        case .arr: nil
        case .revenueAllTime: "All-time"
        }
    }
    
    var chartName: RCChartName? {
        switch self {
        case .mrr: .mrr
        case .subsciptions: .actives
        case .trials: .trials
        case .revenue: .revenue
        case .users: nil
        case .installs: nil
        case .arr: .arr
        case .revenueAllTime: .revenue
        }
    }
    
    var chartIndex: Int? {
        switch self {
        case .mrr: 1
        case .subsciptions: 1
        case .trials: 1
        case .revenue: 3
        case .users: nil
        case .installs: nil
        case .arr: 1
        case .revenueAllTime: 3
        }
    }
    
    init?(chartName: RCChartName) {
        switch chartName {
        case .actives:
            self = .subsciptions
        case .activesMovement:
            return nil
        case .arr:
            self = .arr
        case .churn:
            return nil
        case .conversionToPaying:
            return nil
        case .initialConversion:
            return nil
        case .ltvPerCustomer:
            return nil
        case .ltvPerPayingCustomer:
            return nil
        case .mrr:
            self = .mrr
        case .mrrMovement:
            return nil
        case .refundRate:
            return nil
        case .revenue:
            self = .revenue
        case .subscriptionRetention:
            return nil
        case .trialConversion:
            return nil
        case .trials:
            self = .trials
        case .trialsMovement:
            return nil
        }
    }
}
