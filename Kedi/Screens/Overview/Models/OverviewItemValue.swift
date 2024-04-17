//
//  OverviewItemValue.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import Foundation

enum OverviewItemValue: Hashable, Equatable {
    
    case mrr(Double)
    case subscriptions(Int)
    case trials(Int)
    case revenue(Double)
    case users(Int)
    case installs(Int)
    case arr(Double)
    case proceeds(Double)
    case newUsers(Int)
    case churnRate(Double)
    case subscriptionsLost(Int)
    
    var type: OverviewItemType {
        switch self {
        case .mrr: .mrr
        case .subscriptions: .subscriptions
        case .trials: .trials
        case .revenue: .revenue
        case .users: .users
        case .installs: .installs
        case .arr: .arr
        case .proceeds: .proceeds
        case .newUsers: .newUsers
        case .churnRate: .churnRate
        case .subscriptionsLost: .subscriptionsLost
        }
    }
    
    var formatted: String {
        switch self {
        case .mrr(let double),
                .revenue(let double),
                .arr(let double),
                .proceeds(let double):
            return double.formatted(.currency(code: "USD"))
        case .subscriptions(let int),
                .trials(let int),
                .users(let int),
                .installs(let int),
                .newUsers(let int),
                .subscriptionsLost(let int):
            return int.formatted()
        case .churnRate(let double):
            return (double / 100).formatted(.percent)
        }
    }
    
    init(type: OverviewItemType, value: Double) {
        switch type {
        case .mrr:
            self = .mrr(value)
        case .subscriptions:
            self = .subscriptions(Int(value))
        case .trials:
            self = .trials(Int(value))
        case .revenue:
            self = .revenue(value)
        case .users:
            self = .users(Int(value))
        case .installs:
            self = .installs(Int(value))
        case .arr:
            self = .arr(value)
        case .proceeds:
            self = .proceeds(value)
        case .newUsers:
            self = .newUsers(Int(value))
        case .churnRate:
            self = .churnRate(value)
        case .subscriptionsLost:
            self = .subscriptionsLost(Int(value))
        }
    }
}

extension OverviewItemValue {
    
    static func placeholder(type: OverviewItemType) -> Self {
        let data = RCOverviewResponse.stub
        switch type {
        case .mrr:
            return .mrr(data.mrr ?? 0)
        case .subscriptions:
            return.subscriptions(data.subscriptions ?? 0)
        case .trials:
            return .trials(data.trials ?? 0)
        case .revenue:
            return .revenue(data.revenue ?? 0)
        case .users:
            return .users(data.users ?? 0)
        case .installs:
            return .installs(data.installs ?? 0)
        case .arr:
            return .arr(5234.342)
        case .proceeds:
            return .proceeds(89455.656)
        case .newUsers:
            return .newUsers(23433)
        case .churnRate:
            return .churnRate(23)
        case .subscriptionsLost:
            return .subscriptionsLost(433)
        }
    }
}
