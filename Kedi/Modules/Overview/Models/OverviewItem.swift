//
//  OverviewItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

struct OverviewItem: Hashable {
    
    enum `Type` {
        case mrr
        case subsciptions
        case trials
        case revenue
        case users
        case installs
        
        var icon: String {
            switch self {
            case .mrr: "dollarsign.arrow.circlepath"
            case .subsciptions: "repeat"
            case .trials: "clock"
            case .revenue: "dollarsign"
            case .users: "person.2"
            case .installs: "iphone"
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
            }
        }
        
        var chartType: RCChartType? {
            switch self {
            case .mrr: .mrr
            case .subsciptions: .actives
            case .trials: .trials
            case .revenue: .revenue
            case .users: nil
            case .installs: nil
            }
        }
    }
    
    var icon: String { type.icon }
    var name: String { type.name }
    var note: String? { type.note }
    
    var type: `Type`
    var value: String
}

extension OverviewItem {
    
    static let stub: [Self] = {
        let data = RCOverviewModel.stub
        return [
            .init(type: .mrr, value: "\(data.mrr?.formatted(.currency(code: "USD")) ?? "")"),
            .init(type: .subsciptions, value: "\(data.activeSubscribersCount?.formatted() ?? "")"),
            .init(type: .trials, value: "\(data.activeTrialsCount?.formatted() ?? "")"),
            .init(type: .revenue, value: "\(data.revenue?.formatted(.currency(code: "USD")) ?? "")"),
            .init(type: .users, value: "\(data.activeUsersCount?.formatted() ?? "")"),
            .init(type: .installs, value: "\(data.installsCount?.formatted() ?? "")")
        ]
    }()
}
