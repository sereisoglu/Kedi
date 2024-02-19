//
//  OverviewViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import Foundation

final class OverviewViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    private let meManager = MeManager.shared
    private let widgetsManager = WidgetsManager.shared
    
    @Published private(set) var state: GeneralState = .loading
    
    @Published private(set) var items: [OverviewItem] = .stub
    @Published private(set) var chartValues = [OverviewItemType: [LineAndAreaMarkChartValue]]()
    
    init() {
        Task {
            await fetchAll()
        }
    }
    
    private func fetchAll() async {
        await withDiscardingTaskGroup { group in
            group.addTask { [weak self] in
                await self?.fetchOverview()
            }
            
            group.addTask { [weak self] in
                await self?.fetchCharts()
            }
        }
    }
    
    @MainActor
    private func fetchOverview() async {
        do {
            let data = try await apiService.request(
                type: RCOverviewResponse.self,
                endpoint: .overview
            )
            
            items = [
                .init(type: .mrr, value: "\(data?.mrr?.formatted(.currency(code: "USD")) ?? "")"),
                .init(type: .subsciptions, value: "\(data?.activeSubscribersCount?.formatted() ?? "")"),
                .init(type: .trials, value: "\(data?.activeTrialsCount?.formatted() ?? "")"),
                .init(type: .revenue, value: "\(data?.revenue?.formatted(.currency(code: "USD")) ?? "")"),
                .init(type: .users, value: "\(data?.activeUsersCount?.formatted() ?? "")"),
                .init(type: .installs, value: "\(data?.installsCount?.formatted() ?? "")")
            ]
            
            state = .data
        } catch {
            items = []
            state = .error(error)
        }
    }
    
    @MainActor
    private func fetchCharts() async {
        let charts = await fetchAllCharts()
        let chartsByName = charts.keyBy(\.name)
        
        chartValues = OverviewItemType.allCases.reduce(
            [OverviewItemType: [LineAndAreaMarkChartValue]](),
            { partialResult, itemType in
                var partialResult = partialResult
                if let chartName = itemType.chartName,
                   let chartIndex = itemType.chartIndex,
                   let values = chartsByName[chartName]?.values {
                    partialResult[itemType] = values.map { .init(
                        date: .init(timeIntervalSince1970: $0[safe: 0] ?? 0),
                        value: $0[safe: chartIndex] ?? 0
                    ) }
                }
                return partialResult
            }
        )
        
        if let value = chartValues[.arr]?.last?.value {
            items.append(.init(type: .arr, value: value.formatted(.currency(code: "USD"))))
        }
        
        if let value = chartsByName[.revenue]?.summary?["total"]?["Total Revenue"] {
            items.append(.init(type: .revenueAllTime, value: value.formatted(.currency(code: "USD"))))
        }
        
        if let value = chartValues[.proceeds]?.last?.value {
            items.append(.init(type: .proceeds, value: value.formatted(.currency(code: "USD"))))
        }
        
        if let value = chartsByName[.revenue]?.summary?["total"]?["Proceeds"] {
            items.append(.init(type: .proceedsAllTime, value: value.formatted(.currency(code: "USD"))))
        }
        
        if let value = chartsByName[.conversionToPaying]?.values?.last?[safe: 1] {
            items.append(.init(type: .newUsers, value: value.formatted()))
        }
    }
    
    private func fetchAllCharts() async -> [RCChartResponse] {
        await withTaskGroup(of: RCChartResponse?.self) { group in
            RCChartName.allCases.forEach { name in
                group.addTask { [weak self] in
                    try? await self?.apiService.request(
                        type: RCChartResponse.self,
                        endpoint: .charts(.init(
                            name: name,
                            resolution: .month,
                            startDate: self?.meManager.firstTransactionDate?.format(to: .yyy_MM_dd)
                        ))
                    )
                }
            }
            
            var charts = [RCChartResponse]()
            for await chart in group {
                if let chart {
                    charts.append(chart)
                }
            }
            return charts
        }
    }
    
    func refresh() async {
        widgetsManager.reloadAll()
        await fetchAll()
    }
}
