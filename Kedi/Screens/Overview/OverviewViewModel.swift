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
    
    @Published private(set) var state: GeneralState = .data
    
    @Published private(set) var configs: [OverviewItemConfig] = OverviewItemConfig.get()
    @Published private(set) var items: [OverviewItemConfig: OverviewItem] = .placeholder(configs: OverviewItemConfig.get())
    @Published private(set) var isAddDisabled = OverviewItemConfig.get().count >= 20
    @Published private(set) var isRestoreDefaultsDisabled = OverviewItemConfig.current == nil
    
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
            
            setItem(type: .mrr, value: .mrr(data?.mrr ?? 0))
            setItem(type: .subsciptions, value: .subsciptions(data?.activeSubscribersCount ?? 0))
            setItem(type: .trials, value: .trials(data?.activeTrialsCount ?? 0))
            setItem(config: .init(type: .revenue, timePeriod: .last28Days), value: .revenue(data?.revenue ?? 0))
            setItem(config: .init(type: .users, timePeriod: .last28Days), value: .users(data?.activeUsersCount ?? 0))
            setItem(config: .init(type: .installs, timePeriod: .last28Days), value: .installs(data?.installsCount ?? 0))
        } catch {
            state = .error(error)
        }
    }
    
    @MainActor
    private func fetchChart(config: OverviewItemConfig) async {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        
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
            
            var chart: OverviewItemChart?
            if let chartValues {
                chart = .init(chartValues: chartValues, updatedAt: data?.lastComputedAt)
            }
            
            switch type {
            case .mrr,
                    .subsciptions,
                    .trials,
                    .users,
                    .installs:
                items[config]?.set(chart: chart)
            case .revenue:
                if config.timePeriod == .last28Days {
                    items[config]?.set(chart: chart)
                } else {
                    items[config]?.set(value: .revenue(data?.summary?["total"]?["Total Revenue"] ?? 0), chart: chart)
                }
            case .arr:
                items[config]?.set(value: .arr(chartValues?.last?.value ?? 0), chart: chart)
            case .proceeds:
                items[config]?.set(value: .proceeds(data?.summary?["total"]?["Proceeds"] ?? 0), chart: chart)
            case .newUsers:
                items[config]?.set(value: .newUsers(Int(chartValues?.last?.value ?? 0)), chart: chart)
            case .churnRate:
                items[config]?.set(value: .churnRate(chartValues?.last?.value ?? 0), chart: chart)
            case .subsciptionsLost:
                items[config]?.set(value: .subsciptionsLost(Int(chartValues?.last?.value ?? 0)), chart: chart)
            }
        } catch {
            print(error)
        }
    }
    
    func restoreDefaults() {
        OverviewItemConfig.set(to: nil)
        isRestoreDefaultsDisabled = true
        configs = OverviewItemConfig.get()
    }
    
    func refresh() async {
        widgetsManager.reloadAll()
        await fetchAll()
    }
    
    // MARK: - Items
    
    func getItems() -> [OverviewItem] {
        configs.compactMap { items[$0] }
    }
    
    private func setItem(
        type: OverviewItemType,
        value: OverviewItemValue
    ) {
        guard let config = configs.first(where: { $0.type == type }) else {
            return
        }
        items[config]?.set(value: value)
    }
    
    private func setItem(
        config: OverviewItemConfig,
        value: OverviewItemValue?,
        chart: OverviewItemChart? = nil
    ) {
        if let value {
            items[config]?.set(value: value, chart: chart)
        } else {
            items[config]?.set(chart: chart)
        }
    }
    
    func addItem(config: OverviewItemConfig) {
        let item = OverviewItem(config: config)
        
        configs.insert(config, at: 0)
        items[config] = item
        
        OverviewItemConfig.set(to: configs)
        isRestoreDefaultsDisabled = false
        isAddDisabled = configs.count >= 20
        
        Task {
            await fetchChart(config: config)
        }
    }
    
    func updateItem(config: OverviewItemConfig, timePeriod: OverviewItemTimePeriod) {
        guard let index = configs.firstIndex(where: { $0 == config }) else {
            return
        }
        
        let newConfig = OverviewItemConfig(type: config.type, timePeriod: timePeriod)
        let item = OverviewItem(config: config)
        
        configs[index].timePeriod = timePeriod
        items[config] = nil
        items[newConfig] = item
        
        OverviewItemConfig.set(to: configs)
        isRestoreDefaultsDisabled = false
        
        Task {
            await fetchChart(config: config)
        }
    }
    
    func removeItem(config: OverviewItemConfig) {
        guard let index = configs.firstIndex(where: { $0 == config }) else {
            return
        }
        configs.remove(at: index)
        items[config] = nil
        
        OverviewItemConfig.set(to: configs)
        isRestoreDefaultsDisabled = false
        isAddDisabled = configs.count >= 20
    }
}
