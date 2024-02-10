//
//  OverviewItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

struct OverviewItem: Identifiable, Hashable {
    
    var id: String { type.rawValue }
    var icon: String { type.icon }
    var name: String { type.name }
    var note: String? { type.note }
    
    var type: OverviewItemType
    var value: String
}

extension Array where Element == OverviewItem {
    
    static let stub: Self = {
        let data = RCOverviewResponse.stub
        let arr: Double = 5234.342
        let revenueAllTime: Double = 999999.9999
        return [
            .init(type: .mrr, value: "\(data.mrr?.formatted(.currency(code: "USD")) ?? "")"),
            .init(type: .subsciptions, value: "\(data.activeSubscribersCount?.formatted() ?? "")"),
            .init(type: .trials, value: "\(data.activeTrialsCount?.formatted() ?? "")"),
            .init(type: .revenue, value: "\(data.revenue?.formatted(.currency(code: "USD")) ?? "")"),
            .init(type: .users, value: "\(data.activeUsersCount?.formatted() ?? "")"),
            .init(type: .installs, value: "\(data.installsCount?.formatted() ?? "")"),
            .init(type: .arr, value: "\(arr.formatted(.currency(code: "USD")))"),
            .init(type: .revenueAllTime, value: "\(revenueAllTime.formatted(.currency(code: "USD")))")
        ]
    }()
}
