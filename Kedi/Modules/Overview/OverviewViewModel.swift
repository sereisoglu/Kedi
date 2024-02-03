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
    
    init() {
        Task {
            await fetchOverview { [weak self] success in
                if success {
                    self?.state = .data
                } else {
                    self?.state = .empty
                }
            }
        }
    }
    
    @MainActor
    private func fetchOverview(completion: ((Bool) -> Void)? = nil) async {
        do {
            let data = try await apiService.request(
                type: RCOverviewModel.self,
                endpoint: .overview
            )
            items = [
                .init(name: "MRR", value: "\(data?.mrr?.formatted(.currency(code: "USD")) ?? "")"),
                .init(name: "Subsciptions", value: "\(data?.activeSubscribersCount ?? 0)"),
                .init(name: "Trials", value: "\(data?.activeTrialsCount ?? 0)"),
                .init(name: "Revenue", value: "\(data?.revenue?.formatted(.currency(code: "USD")) ?? "")"),
                .init(name: "Users", value: "\(data?.activeUsersCount ?? 0)"),
                .init(name: "Installs", value: "\(data?.installsCount ?? 0)")
            ]
            completion?(true)
        } catch {
            completion?(false)
        }
    }
}
