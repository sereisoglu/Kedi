//
//  OverviewItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

struct OverviewItem: Identifiable, Hashable {
    
    private(set) var config: OverviewItemConfig
    private(set) var value: OverviewItemValue
    private(set) var valueState: GeneralState = .loading
    private(set) var chart: OverviewItemChart?
    
    var id: String { "\(type.rawValue)-\(config.timePeriod)" }
    var type: OverviewItemType { value.type }
    var icon: String { type.icon }
    var title: String { type.title }
    var subtitle: String? {
        switch type.valueType {
        case .live:
            return nil
        case .last:
            return config.timePeriod.resolutionTitle
        case .average:
            return "Average \(config.timePeriod.title.lowercased())"
        case .total:
            return config.timePeriod.title
        }
    }
    var caption: String? {
        guard chart != nil,
              type.valueType != .total else {
            return nil
        }
        return "Graph shows \(config.timePeriod.title.lowercased())"
    }
    
    init(
        config: OverviewItemConfig,
        value: OverviewItemValue,
        valueState: GeneralState = .loading,
        chart: OverviewItemChart? = nil
    ) {
        self.config = config
        self.value = value
        self.valueState = valueState
        self.chart = chart
    }
    
    init(config: OverviewItemConfig) {
        self.config = config
        value = .placeholder(type: config.type)
    }
    
    mutating func set(value: OverviewItemValue) {
        valueState = .data
        self.value = value
    }
    
    mutating func set(chart: OverviewItemChart?) {
        self.chart = chart
    }
    
    mutating func set(valueState: GeneralState) {
        guard self.valueState != .data else {
            return
        }
        self.valueState = valueState
    }
}

extension Dictionary where Key == OverviewItemConfig, Value == OverviewItem {
    
    static func placeholder(configs: [OverviewItemConfig]) -> Self {
        configs.reduce([OverviewItemConfig: OverviewItem]()) { partialResult, config in
            var partialResult = partialResult
            partialResult[config] = .init(config: config, value: .placeholder(type: config.type))
            return partialResult
        }
    }
}
