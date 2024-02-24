//
//  OverviewItemValue.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import Foundation

enum OverviewItemValue: Hashable, Equatable {
    
    case mrr(Double)
    case subsciptions(Int)
    case trials(Int)
    case revenue(Double)
    case users(Int)
    case installs(Int)
    case arr(Double)
    case proceeds(Double)
    case newUsers(Int)
    case churnRate(Double)
    case subsciptionsLost(Int)
    
    var type: OverviewItemType {
        switch self {
        case .mrr: .mrr
        case .subsciptions: .subsciptions
        case .trials: .trials
        case .revenue: .revenue
        case .users: .users
        case .installs: .installs
        case .arr: .arr
        case .proceeds: .proceeds
        case .newUsers: .newUsers
        case .churnRate: .churnRate
        case .subsciptionsLost: .subsciptionsLost
        }
    }
    
    var formatted: String {
        switch self {
        case .mrr(let double),
                .revenue(let double),
                .arr(let double),
                .proceeds(let double):
            return double.formatted(.currency(code: "USD"))
        case .subsciptions(let int),
                .trials(let int),
                .users(let int),
                .installs(let int),
                .newUsers(let int),
                .subsciptionsLost(let int):
            return int.formatted()
        case .churnRate(let double):
            return (double / 100).formatted(.percent)
        }
    }
    
    static func placeholder(type: OverviewItemType) -> Self {
        let data = RCOverviewResponse.stub
        switch type {
        case .mrr: 
            return .mrr(data.mrr ?? 0)
        case .subsciptions: 
            return.subsciptions(data.activeSubscribersCount ?? 0)
        case .trials:
            return .trials(data.activeTrialsCount ?? 0)
        case .revenue:
            return .revenue(data.revenue ?? 0)
        case .users:
            return .users(data.activeUsersCount ?? 0)
        case .installs:
            return .installs(data.installsCount ?? 0)
        case .arr:
            return .arr(5234.342)
        case .proceeds:
            return .proceeds(89455.656)
        case .newUsers:
            return .newUsers(23433)
        case .churnRate:
            return .churnRate(23)
        case .subsciptionsLost:
            return .subsciptionsLost(433)
        }
    }
}
