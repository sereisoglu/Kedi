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
    
    @Published private(set) var configs: [OverviewItemConfig] = .get()
    @Published private(set) var items: [OverviewItemType: OverviewItem] = .placeholder(configs: .get())
    
    func getItems() -> [OverviewItem] {
        configs.compactMap { config in
            items[config.type]
        }
    }
    
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
            
            configs.forEach { config in
                group.addTask { [weak self] in
                    await self?.fetchChart(config: config)
                }
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
            
            items[.mrr]?.set(value: .mrr(data?.mrr ?? 0))
            items[.subsciptions]?.set(value: .subsciptions(data?.activeSubscribersCount ?? 0))
            items[.trials]?.set(value: .trials(data?.activeTrialsCount ?? 0))
            items[.revenue]?.set(value: .revenue(data?.revenue ?? 0))
            items[.users]?.set(value: .users(data?.activeUsersCount ?? 0))
            items[.installs]?.set(value: .installs(data?.installsCount ?? 0))
            
//            state = .data
        } catch {
//            state = .error(error)
        }
    }
    
    @MainActor
    private func fetchChart(config: OverviewItemConfig) async {
        let type = config.type
        
        guard let chartName = type.chartName,
              let chartIndex = type.chartIndex else {
            return
        }
        
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
            
            let chartValues: [LineAndAreaMarkChartValue]? = data?.values?.map { .init(
                date: .init(timeIntervalSince1970: $0[safe: 0] ?? 0),
                value: $0[safe: chartIndex] ?? 0
            ) }
            
            switch type {
            case .mrr,
                    .subsciptions,
                    .trials,
                    .revenue,
                    .users,
                    .installs:
                items[type]?.chartValues = chartValues
            case .arr:
                items[type]?.set(value: .arr(chartValues?.last?.value ?? 0), chartValues: chartValues)
            case .proceeds:
                items[type]?.set(value: .proceeds(data?.summary?["total"]?["Total Revenue"] ?? 0), chartValues: chartValues)
            case .newUsers:
                items[type]?.set(value: .newUsers(Int(chartValues?.last?.value ?? 0)), chartValues: chartValues)
            case .churnRate:
                items[type]?.set(value: .churnRate(chartValues?.last?.value ?? 0), chartValues: chartValues)
            case .subsciptionsLost:
                items[type]?.set(value: .subsciptionsLost(Int(chartValues?.last?.value ?? 0)), chartValues: chartValues)
            }
            
//            state = .data
        } catch {
//            state = .error(error)
        }
    }
    
    func refresh() async {
        widgetsManager.reloadAll()
        await fetchAll()
    }
}
