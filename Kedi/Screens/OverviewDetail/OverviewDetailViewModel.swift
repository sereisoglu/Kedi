//
//  OverviewDetailViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/5/24.
//

import Foundation

final class OverviewDetailViewModel: ObservableObject {
    
    let item: OverviewItem
    @Published private(set) var value: OverviewItemValue
    @Published private(set) var chartValues: [OverviewItemChartValue]
    
    @Published private(set) var state: GeneralState = .data
    
    @Published var timePeriodSelection: OverviewItemTimePeriod
    @Published var selectedChartValue: OverviewItemChartValue?
    
    var title: String {
        if let selectedChartValue {
            return OverviewItemValue(type: item.type, value: selectedChartValue.value).formatted
        } else {
            return value.formatted
        }
    }
    
    var subtitle: String {
        if let selectedChartValue {
            return selectedChartValue.date.formatted(date: .abbreviated, time: .omitted)
        } else {
            guard let firstDate = chartValues.first?.date,
                  let lastDate = chartValues.last?.date else {
                return " "
            }
            return "\(firstDate.formatted(date: .abbreviated, time: .omitted)) - \(lastDate.formatted(date: .abbreviated, time: .omitted))"
        }
    }
    
    var chartXScale: ClosedRange<Date> {
        (chartValues.first?.date ?? .now)...(chartValues.last?.date ?? .now)
    }
    
    var chartXValues: [Date] {
        let dates = chartValues.map(\.date)
        return stride(from: 0, to: dates.count, by: Int(dates.count / 3)).map { dates[$0] }
    }
    
    var chartYScale: ClosedRange<Double> {
        var max = chartValues.map(\.value).max() ?? 0
        let toNearest = Double(Int(max).size)
        
        var min = chartValues.map(\.value).min() ?? 0
        min = min >= 0 ? 0 : min.floorToNearest(toNearest)
        
        max =  max.ceilToNearest(toNearest)
        
        return min...max
    }
    
    init(item: OverviewItem) {
        self.item = item
        value = item.value
        chartValues = item.chart?.values ?? []
        timePeriodSelection = item.config.timePeriod
    }
    
    func onTimePeriodChange() {
        
    }
}
