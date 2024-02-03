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
    @Published var chartValues: [RCChartType: [LineAndAreaMarkChartValue]]?
    
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
    }
    
    @MainActor
    private func fetchCharts() async {
        do {
            chartValues = try await fetchAllCharts()
        } catch {
            print(error)
        }
    }
    
    private func fetchAllCharts() async throws -> [RCChartType: [LineAndAreaMarkChartValue]]? {
        try await withThrowingTaskGroup(of: RCChartModel?.self) { group in
            RCChartType.allCases.forEach { type in
                group.addTask { [weak self] in
                    try await self?.apiService.request(
                        type: RCChartModel.self,
                        endpoint: .charts(type: type, resolution: .month, startDate: "2020-01-01")
                    )
                }
            }
            
            var chartValues = [RCChartType: [LineAndAreaMarkChartValue]]()
            for try await chart in group {
                if let type = chart?.type,
                   let values = chart?.values {
                    switch type {
                    case .revenue:
                        chartValues[type] = values.map { .init(date: Date(timeIntervalSince1970: $0[safe: 0] ?? 0), value: $0[safe: 3] ?? 0) }
                    default:
                        chartValues[type] = values.map { .init(date: Date(timeIntervalSince1970: $0[safe: 0] ?? 0), value: $0[safe: 1] ?? 0) }
                    }
                }
            }
            return chartValues
        }
    }
}
