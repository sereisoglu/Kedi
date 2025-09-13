//
//  OverviewItemType.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

enum OverviewItemType: String, Codable, CaseIterable {
    
    case mrr
    case subscriptions
    case trials
    case revenue
    case users
    case newUsers
    case arr
    case proceeds
    case churnRate
    case subscriptionsLost
    case transactions
    
    var icon: String {
        switch self {
        case .mrr: "dollarsign.arrow.circlepath"
        case .subscriptions: "repeat"
        case .trials: "clock"
        case .revenue: "dollarsign.circle"
        case .users: "person.2"
        case .newUsers: "person.badge.plus"
        case .arr: "dollarsign.arrow.circlepath"
        case .proceeds: "dollarsign.circle"
        case .churnRate: "person.2.slash"
        case .subscriptionsLost: "person.2.slash"
        case .transactions: "arrow.left.arrow.right.circle"
        }
    }
    
    var title: String {
        switch self {
        case .mrr: "MRR"
        case .subscriptions: "Subscriptions"
        case .trials: "Trials"
        case .revenue: "Revenue"
        case .users: "Users"
        case .newUsers: "New Users"
        case .arr: "ARR"
        case .proceeds: "Proceeds"
        case .churnRate: "Churn Rate"
        case .subscriptionsLost: "Subs. Lost"
        case .transactions: "Transactions"
        }
    }
    
    var availableTimePeriods: [OverviewItemTimePeriod] {
        switch self {
        case .users:
            [.last28Days]
        default:
            [
                .last7Days,
                .last28Days,
                .last90Days,
                .last12Months,
                .thisWeek,
                .thisMonth,
                .thisYear,
                .allTime
            ]
        }
    }
    
    var valueType: OverviewItemValueType {
        switch self {
        case .mrr: .live
        case .subscriptions: .live
        case .trials: .live
        case .revenue: .total
        case .users: .total
        case .newUsers: .total
        case .arr: .live
        case .proceeds: .total
        case .churnRate: .last
        case .subscriptionsLost: .last
        case .transactions: .total
        }
    }
    
    var chartName: RCChartName? {
        switch self {
        case .mrr: .mrr
        case .subscriptions: .actives
        case .trials: .trials
        case .revenue: .revenue
        case .users: nil
        case .newUsers: .newUsers
        case .arr: .arr
        case .proceeds: .revenue
        case .churnRate: .churn
        case .subscriptionsLost: .churn
        case .transactions: .revenue
        }
    }
    
    var chartIndex: Int? {
        switch self {
        case .mrr: 0
        case .subscriptions: 0
        case .trials: 0
        case .revenue: 0
        case .users: nil
        case .newUsers: 0
        case .arr: 0
        case .proceeds: 0
        case .churnRate: 2
        case .subscriptionsLost: 1
        case .transactions: 1
        }
    }
    
    var chartRevenueType: RCChartRevenueType? {
        switch self {
        case .mrr: nil
        case .subscriptions: nil
        case .trials: nil
        case .revenue: .revenue
        case .users: nil
        case .newUsers: nil
        case .arr: nil
        case .proceeds: .proceeds
        case .churnRate: nil
        case .subscriptionsLost: nil
        case .transactions: .revenue
        }
    }
}

enum OverviewItemValueType {
    
    case live
    case last
    case average
    case total
}
