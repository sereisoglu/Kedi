//
//  OverviewItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

struct OverviewItem: Hashable {
    
    var name: String
    var value: String
    var note: String? = nil
}

extension OverviewItem {
    
    static let stub: [Self] = {
        let data = RCOverviewModel.stub
        return [
            .init(name: "MRR", value: "\(data.mrr?.formatted(.currency(code: "USD")) ?? "")"),
            .init(name: "Subsciptions", value: "\(data.activeSubscribersCount ?? 0)"),
            .init(name: "Trials", value: "\(data.activeTrialsCount ?? 0)"),
            .init(name: "Revenue", value: "\(data.revenue?.formatted(.currency(code: "USD")) ?? "")", note: "Last 28 days"),
            .init(name: "Users", value: "\(data.activeUsersCount ?? 0)", note: "Last 28 days"),
            .init(name: "Installs", value: "\(data.installsCount ?? 0)", note: "Last 28 days")
        ]
    }()
}
