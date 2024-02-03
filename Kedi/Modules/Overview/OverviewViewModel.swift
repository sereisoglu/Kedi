//
//  OverviewViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import Foundation

final class OverviewViewModel: ObservableObject {
    
    enum State {
        case loading
        case empty
        case error(Error)
        case data
    }
    
    private let apiService = APIService.shared
    
    @Published var state: State = .loading
    
    @Published var items = [OverviewItem]()
    @Published var chartValues = [RCChartName: [LineAndAreaMarkChartValue]]()
    
    @MainActor
    init() {
        Task {
            await withDiscardingTaskGroup { group in
                group.addTask { [weak self] in
                    await self?.fetchOverview()
                }
                
                group.addTask { [weak self] in
                    await self?.fetchCharts()
                }
            }
        }
    }
    
    @MainActor
    private func fetchOverview() async {
        do {
            let data = try await apiService.request(
                type: RCOverviewModel.self,
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
            state = .error(error)
        }
        
//        items = OverviewItem.stub
//        state = .data
    }
    
    @MainActor
    private func fetchCharts() async {
        let charts = await fetchAllCharts()
        let chartsByName = charts.keyBy(\.name)
        
        chartValues = charts.reduce([RCChartName: [LineAndAreaMarkChartValue]](), { partialResult, chart in
            var partialResult = partialResult
            if let name = chart.name,
               let index = OverviewItemType(chartName: name)?.chartIndex,
               let values = chart.values {
                partialResult[name] = values.map { .init(
                    date: .init(timeIntervalSince1970: $0[safe: 0] ?? 0),
                    value: $0[safe: index] ?? 0
                ) }
            }
            return partialResult
        })
        
        if let value = chartValues[.arr]?.last?.value {
            items.append(.init(type: .arr, value: value.formatted(.currency(code: "USD"))))
        }
        
        if let value = chartsByName[.revenue]?.summary?["total"]?["Total Revenue"] {
            items.append(.init(type: .revenueAllTime, value: value.formatted(.currency(code: "USD"))))
        }
    }
    
    private func fetchAllCharts() async -> [RCChartModel] {
        await withTaskGroup(of: RCChartModel?.self) { group in
            RCChartName.allCases.forEach { name in
                group.addTask { [weak self] in
                    do {
                        return try await self?.apiService.request(
                            type: RCChartModel.self,
                            endpoint: .charts(name: name, resolution: .month, startDate: "2020-01-11")
                        )
                    } catch {
                        print(error)
                        return nil
                    }
                }
            }
            
            var charts = [RCChartModel]()
            for await chart in group {
                if let chart {
                    charts.append(chart)
                }
            }
            return charts
        }
    }
}
