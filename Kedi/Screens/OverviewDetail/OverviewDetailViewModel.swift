//
//  OverviewDetailViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/5/24.
//

import Foundation

final class OverviewDetailViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    
    let item: OverviewItem
    @Published private(set) var value: OverviewItemValue
    @Published private(set) var chartValues: [OverviewItemChartValue]
    
    @Published private(set) var state: ViewState = .data
    
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
        let values = chartValues.map(\.value)
        var max = values.max() ?? 0
        let toNearest = Double(Int(max).size)
        
        max = max.ceilToNearest(toNearest)
        
        var min = values.min() ?? 0
        min = min >= 0 ? 0 : min.floorToNearest(toNearest)
        
        return min...max
    }
    
    init(item: OverviewItem) {
        self.item = item
        value = item.value
        chartValues = item.chart?.values ?? []
        timePeriodSelection = item.config.timePeriod
    }
    
    func onTimePeriodChange() {
        Task {
            await fetchChart(config: .init(type: item.type, timePeriod: timePeriodSelection))
        }
    }
    
    @MainActor
    private func fetchChart(config: OverviewItemConfig) async {
        let type = config.type
        
        guard let chartName = type.chartName,
              let chartIndex = type.chartIndex else {
            return
        }
        
        state = .loading
        
        do {
            let data = try await apiService.request(
                type: RCChartResponse.self,
                endpoint: .charts(.init(
                    name: chartName,
                    resolution: config.timePeriod.resolution,
                    startDate: config.timePeriod.startDate,
                    endDate: config.timePeriod.endDate
                ))
            )
            
            chartValues = data?.values?.map { .init(
                date: .init(timeIntervalSince1970: $0[safe: 0] ?? 0).withoutTime,
                value: $0[safe: chartIndex] ?? 0
            ) } ?? []
            
            switch type {
            case .mrr,
                    .subscriptions,
                    .trials,
                    .users,
                    .installs:
                break
            case .revenue:
                if config.timePeriod == .last28Days {
                    break
                } else {
                    value = .revenue(data?.summary?["total"]?["Total Revenue"] ?? 0)
                }
            case .arr:
                value = .arr(chartValues.last?.value ?? 0)
            case .proceeds:
                value = .proceeds(data?.summary?["total"]?["Proceeds"] ?? 0)
            case .newUsers:
                value = .newUsers(Int(chartValues.last?.value ?? 0))
            case .churnRate:
                value = .churnRate(chartValues.last?.value ?? 0)
            case .subscriptionsLost:
                value = .subscriptionsLost(Int(chartValues.last?.value ?? 0))
            }
            
            state = chartValues.isEmpty ? .empty : .data
        } catch {
            state = .error(error)
        }
    }
}
