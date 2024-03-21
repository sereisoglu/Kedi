//
//  OverviewItemConfig.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import Foundation

struct OverviewItemConfig: Codable, Hashable {
    
    var type: OverviewItemType
    var timePeriod: OverviewItemTimePeriod
}

extension OverviewItemConfig {
    
    static var current: [Self]? {
        guard let data = UserDefaults.shared.overviewConfigs else {
            return nil
        }
        return try? JSONDecoder().decode([Self].self, from: data)
    }
    
    static let defaults: [Self] = {
        return [
            .init(type: .mrr, timePeriod: .allTime),
            .init(type: .subscriptions, timePeriod: .allTime),
            .init(type: .trials, timePeriod: .allTime),
            .init(type: .revenue, timePeriod: .last28Days),
            .init(type: .users, timePeriod: .last28Days),
            .init(type: .installs, timePeriod: .last28Days),
            .init(type: .arr, timePeriod: .allTime),
            .init(type: .proceeds, timePeriod: .allTime),
            .init(type: .newUsers, timePeriod: .allTime),
            .init(type: .churnRate, timePeriod: .allTime),
            .init(type: .subscriptionsLost, timePeriod: .allTime)
        ]
    }()
    
    static func get() -> [Self] {
        current ?? defaults
    }
    
    static func set(to configs: [Self]?) {
        UserDefaults.shared.overviewConfigs = try? JSONEncoder().encode(configs)
    }
    
    static func isAvailable(config: Self) -> Bool {
        let configs = get()
        if config.type.valueType == .live {
            return !configs.contains(where: { $0.type == config.type })
        } else {
            return !configs.contains(config)
        }
    }
}
