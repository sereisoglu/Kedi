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
    
    private var overviewData: RCOverviewResponse?
    
    @Published private(set) var state: ViewState = .data
    
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
    private func fetch(for config: OverviewItemConfig) async {
        switch config.type {
        case .mrr:
            setItem(type: .mrr, value: .mrr(overviewData?.mrr ?? 0))
        case .subscriptions:
            setItem(type: .subscriptions, value: .subscriptions(overviewData?.subscriptions ?? 0))
        case .trials:
            setItem(type: .trials, value: .trials(overviewData?.trials ?? 0))
        case .revenue:
            if config.timePeriod == .last28Days {
                setItem(config: .init(type: .revenue, timePeriod: .last28Days), value: .revenue(overviewData?.revenue ?? 0))
            }
        case .users:
            setItem(config: .init(type: .users, timePeriod: .last28Days), value: .users(overviewData?.users ?? 0))
        case .installs:
            setItem(config: .init(type: .installs, timePeriod: .last28Days), value: .installs(overviewData?.installs ?? 0))
        default:
            break
        }
        
        await fetchChart(config: config)
    }
    
    @MainActor
    private func fetchOverview() async {
        do {
            overviewData = try await apiService.request(
                type: RCOverviewResponse.self,
                endpoint: .overview(projectIds: nil)
            )
            
            setItem(type: .mrr, value: .mrr(overviewData?.mrr ?? 0))
            setItem(type: .subscriptions, value: .subscriptions(overviewData?.subscriptions ?? 0))
            setItem(type: .trials, value: .trials(overviewData?.trials ?? 0))
            setItem(config: .init(type: .revenue, timePeriod: .last28Days), value: .revenue(overviewData?.revenue ?? 0))
            setItem(config: .init(type: .users, timePeriod: .last28Days), value: .users(overviewData?.users ?? 0))
            setItem(config: .init(type: .installs, timePeriod: .last28Days), value: .installs(overviewData?.installs ?? 0))
        } catch {
            state = .error(error)
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
                    endDate: config.timePeriod.endDate,
                    revenueType: type.chartRevenueType
                ))
            )
            
            let chartValues: [OverviewItemChartValue]? = data?.values?.map { .init(
                date: .init(timeIntervalSince1970: $0[safe: 0] ?? 0).withoutTime,
                value: $0[safe: chartIndex] ?? 0
            ) }
            
            if let chartValues {
                let chart = OverviewItemChart(values: chartValues, updatedAt: data?.lastComputedAt)
                switch type {
                case .mrr,
                        .subscriptions,
                        .trials,
                        .users,
                        .installs:
                    setItem(config: config, chart: chart)
                case .revenue:
                    if config.timePeriod == .last28Days {
                        setItem(config: config, chart: chart)
                    } else {
                        setItem(config: config, value: .revenue(data?.summary?["total"]?["Revenue"] ?? 0), chart: chart)
                    }
                case .arr:
                    setItem(config: config, value: .arr(chartValues.last?.value ?? 0), chart: chart)
                case .proceeds:
                    setItem(config: config, value: .proceeds(data?.summary?["total"]?["Proceeds"] ?? 0), chart: chart)
                case .newUsers:
                    setItem(config: config, value: .newUsers(Int(chartValues.last?.value ?? 0)), chart: chart)
                case .churnRate:
                    setItem(config: config, value: .churnRate(chartValues.last?.value ?? 0), chart: chart)
                case .subscriptionsLost:
                    setItem(config: config, value: .subscriptionsLost(Int(chartValues.last?.value ?? 0)), chart: chart)
                case .transactions:
                    setItem(config: config, value: .transactions(Int(data?.summary?["total"]?["Transactions"] ?? 0)), chart: chart)
                }
            } else {
                items[config]?.set(valueState: .empty)
            }
        } catch {
            items[config]?.set(valueState: .error(error))
        }
    }
    
    func restoreDefaults() {
        OverviewItemConfig.set(to: nil)
        isRestoreDefaultsDisabled = true
        configs = OverviewItemConfig.get()
        items = .placeholder(configs: configs)
        
        Task {
            await fetchAll()
        }
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
        value: OverviewItemValue
    ) {
        items[config]?.set(value: value)
    }
    
    private func setItem(
        config: OverviewItemConfig,
        chart: OverviewItemChart?
    ) {
        items[config]?.set(chart: chart)
    }
    
    private func setItem(
        config: OverviewItemConfig,
        value: OverviewItemValue,
        chart: OverviewItemChart?
    ) {
        items[config]?.set(value: value)
        items[config]?.set(chart: chart)
    }
    
    func addItem(config: OverviewItemConfig) {
        let item = OverviewItem(config: config)
        
        configs.insert(config, at: 0)
        items[config] = item
        
        OverviewItemConfig.set(to: configs)
        isRestoreDefaultsDisabled = false
        isAddDisabled = configs.count >= 20
        state = configs.isEmpty ? .empty : .data
        
        Task {
            await fetch(for: config)
        }
    }
    
    func updateItem(
        config: OverviewItemConfig,
        timePeriod: OverviewItemTimePeriod
    ) {
        guard let index = configs.firstIndex(of: config) else {
            return
        }
        
        let newConfig = OverviewItemConfig(type: config.type, timePeriod: timePeriod)
        let item = OverviewItem(config: newConfig)
        
        configs[index].timePeriod = timePeriod
        items[config] = nil
        items[newConfig] = item
        
        OverviewItemConfig.set(to: configs)
        isRestoreDefaultsDisabled = false
        
        Task {
            await fetch(for: newConfig)
        }
    }
    
    func moveItem(
        source: OverviewItem,
        target: OverviewItem
    ) {
        guard let sourceIndex = configs.firstIndex(of: source.config),
              let targetIndex = configs.firstIndex(of: target.config) else {
            return
        }
        
        configs.move(
            fromOffsets: IndexSet(integer: sourceIndex),
            toOffset: targetIndex > sourceIndex ? targetIndex + 1 : targetIndex
        )
        
        OverviewItemConfig.set(to: configs)
        isRestoreDefaultsDisabled = false
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
        state = configs.isEmpty ? .empty : .data
    }
}
