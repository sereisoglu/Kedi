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
    private(set) var chartValues: [LineAndAreaMarkChartValue]?
    
    var id: String { "\(type.rawValue)-\(config.timePeriod)" }
    var type: OverviewItemType { value.type }
    var icon: String { type.icon }
    var title: String { type.title }
    var note: String? {
        switch type {
        case .mrr,
                .subsciptions,
                .trials,
                .arr:
            return "\(config.timePeriod.title) (graph)"
        default:
            return config.timePeriod.title
        }
    }
    
    init(
        config: OverviewItemConfig,
        value: OverviewItemValue,
        valueState: GeneralState = .loading,
        chartValues: [LineAndAreaMarkChartValue]? = nil
    ) {
        self.value = value
        self.chartValues = chartValues
        self.config = config
        self.valueState = valueState
    }
    
    init(config: OverviewItemConfig) {
        self.config = config
        value = .placeholder(type: config.type)
    }
    
    mutating func set(
        value: OverviewItemValue,
        chartValues: [LineAndAreaMarkChartValue]? = nil
    ) {
        valueState = .data
        self.value = value
        self.chartValues = chartValues
    }
    
    mutating func set(chartValues: [LineAndAreaMarkChartValue]?) {
        self.chartValues = chartValues
    }
    
    mutating func set(valueState: GeneralState) {
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
