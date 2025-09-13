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
    @Published private(set) var chartValues = [OverviewItemChartValue]()
    
    @Published private(set) var state: ViewState = .data
    
    @Published var timePeriodSelection: OverviewItemTimePeriod
    @Published var selectedChartValue: OverviewItemChartValue?
    
    @Published private(set) var chartXScale: ClosedRange<Date> = Date.now...Date.now
    @Published private(set) var chartXValues = [Date]()
    @Published private(set) var chartYScale: ClosedRange<Double> = 0...0
    
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
    
    init(item: OverviewItem) {
        self.item = item
        value = item.value
        timePeriodSelection = item.config.timePeriod
        set(chartValues: item.chart?.values ?? [])
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
                .charts(
                    name: chartName,
                    .init(
                        resolution: config.timePeriod.resolution,
                        startDate: config.timePeriod.startDate,
                        endDate: config.timePeriod.endDate,
                        revenueType: type.chartRevenueType
                    )
                )
            ) as RCChartResponse
            
            let chartValues: [OverviewItemChartValue] = data.values?
                .filter { $0.measure == chartIndex }
                .map {
                    .init(
                        date: .init(timeIntervalSince1970: Double($0.cohort ?? 0)).withoutTime,
                        value: $0.value ?? 0
                    )
                } ?? []
            set(chartValues: chartValues)
            
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
                    value = .revenue(data.summary?["total"]?["Revenue"] ?? 0)
                }
            case .arr:
                value = .arr(chartValues.last?.value ?? 0)
            case .proceeds:
                value = .proceeds(data.summary?["total"]?["Proceeds"] ?? 0)
            case .newUsers:
                value = .newUsers(Int(chartValues.last?.value ?? 0))
            case .churnRate:
                value = .churnRate(chartValues.last?.value ?? 0)
            case .subscriptionsLost:
                value = .subscriptionsLost(Int(chartValues.last?.value ?? 0))
            case .transactions:
                value = .transactions(Int(data.summary?["total"]?["Transactions"] ?? 0))
            }
            
            state = chartValues.isEmpty ? .empty : .data
        } catch {
            state = .error(error)
        }
    }
    
    private func set(chartValues: [OverviewItemChartValue]) {
        self.chartValues = chartValues
        
        chartXScale = (chartValues.first?.date ?? .now)...(chartValues.last?.date ?? .now)
        
        let dates = chartValues.map(\.date)
        var by = Int(dates.count / 3)
        by = (by == 0 ? 1 : by)
        chartXValues = stride(from: 0, to: dates.count, by: by).map { dates[$0] }
        
        let values = chartValues.map(\.value)
        var max = values.max() ?? 0
        let toNearest = Double(Int(max).size)
        max = max.ceilToNearest(toNearest)
        var min = values.min() ?? 0
        min = min >= 0 ? 0 : min.floorToNearest(toNearest)
        chartYScale = min...max
    }
}
