//
//  OverviewItemType.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

enum OverviewItemType: String, CaseIterable {
    
    case mrr
    case subsciptions
    case trials
    case revenue
    case users
    case installs
    case arr
    case revenueAllTime
    case proceeds
    case proceedsAllTime
    case newUsers
    
    var icon: String {
        switch self {
        case .mrr: "dollarsign.arrow.circlepath"
        case .subsciptions: "repeat"
        case .trials: "clock"
        case .revenue: "dollarsign.circle"
        case .users: "person.2"
        case .installs: "iphone"
        case .arr: "dollarsign.arrow.circlepath"
        case .revenueAllTime: "dollarsign.circle"
        case .proceeds: "dollarsign.circle"
        case .proceedsAllTime: "dollarsign.circle"
        case .newUsers: "person.2"
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
        case .proceeds: "Proceeds"
        case .proceedsAllTime: "Proceeds"
        case .newUsers: "New Users"
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
        case .proceeds: "This month"
        case .proceedsAllTime: "All-time"
        case .newUsers: "This month"
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
        case .proceeds: .revenue
        case .proceedsAllTime: .revenue
        case .newUsers: .conversionToPaying
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
        case .proceeds: 6
        case .proceedsAllTime: 6
        case .newUsers: 1
        }
    }
}
