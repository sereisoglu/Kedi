//
//  OverviewItemType.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

enum OverviewItemType: String, Codable, CaseIterable {
    
    case mrr
    case subsciptions
    case trials
    case revenue
    case users
    case installs
    case arr
    case proceeds
    case newUsers
    case churnRate
    case subsciptionsLost
    
    var icon: String {
        switch self {
        case .mrr: "dollarsign.arrow.circlepath"
        case .subsciptions: "repeat"
        case .trials: "clock"
        case .revenue: "dollarsign.circle"
        case .users: "person.2"
        case .installs: "iphone"
        case .arr: "dollarsign.arrow.circlepath"
        case .proceeds: "dollarsign.circle"
        case .newUsers: "person.2"
        case .churnRate: "person.2.slash"
        case .subsciptionsLost: "person.2.slash"
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
        case .proceeds: "Proceeds"
        case .newUsers: "New Users"
        case .churnRate: "Churn Rate"
        case .subsciptionsLost: "Subs. Lost"
        }
    }
    
    var availableTimePeriods: [OverviewItemTimePeriod] {
        switch self {
        case .mrr,
                .subsciptions,
                .trials,
                .arr,
                .proceeds,
                .newUsers,
                .churnRate,
                .subsciptionsLost:
            return [
                .last7Days,
                .last30Days,
                .last90Days,
                .last12Months,
//                .lastWeek,
//                .lastMonth,
//                .lastYear,
                .thisWeek,
                .thisMonth,
                .thisYear,
                .allTime
            ]
        case .revenue: 
            return [
                .last7Days,
                .last28Days,
                .last30Days,
                .last90Days,
                .last12Months,
//                .lastWeek,
//                .lastMonth,
//                .lastYear,
                .thisWeek,
                .thisMonth,
                .thisYear,
                .allTime
            ]
        case .users,
                .installs:
            return [.last28Days]
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
        case .proceeds: .revenue
        case .newUsers: .conversionToPaying
        case .churnRate: .churn
        case .subsciptionsLost: .churn
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
        case .proceeds: 6
        case .newUsers: 1
        case .churnRate: 3
        case .subsciptionsLost: 2
        }
    }
}
