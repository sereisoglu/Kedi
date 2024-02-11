//
//  OverviewWidgetProvider.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/10/24.
//

import Foundation
import WidgetKit

struct OverviewWidgetProvider: TimelineProvider {
    
    typealias Entry = OverviewWidgetEntry
    
    private let authManager = AuthManager.shared
    private let apiManager = APIService.shared
    private let cacheManager = CacheManager.shared
    
    func placeholder(in context: Context) -> Entry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        Task {
            await getEntry(context: context, completion: completion)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            await getEntry(context: context) { entry in
                let policy: TimelineReloadPolicy
                if let error = entry.error {
                    if error.isAuthorizationError {
                        policy = .never
                    } else {
                        policy = .after(Date(byAdding: .minute, value: 1))
                    }
                } else {
                    policy = .after(Date(byAdding: .minute, value: 15))
                }
                
                completion(.init(entries: [entry], policy: policy))
            }
        }
    }
    
    private func getEntry(
        context: Context,
        completion: @escaping (Entry) -> Void
    ) async {
        var items = [OverviewItem]()
        var err: RCError?
        do {
            items = try await fetchData()
            cacheManager.setWithEncode(
                key: "widgets/overview",
                data: items,
                expiry: .date(.init(byAdding: .day, value: 3))
            )
        } catch {
            err = error as? RCError
            items = cacheManager.getWithDecode(
                key: "widgets/overview",
                type: [OverviewItem].self
            ) ?? []
        }
        
        if context.isPreview,
           err != nil {
            completion(.placeholder)
        } else {
            completion(.init(date: Date(), items: items, error: err))
        }
    }
    
    private func fetchData() async throws -> [OverviewItem] {
        do {
            let data = try await apiManager.request(
                type: RCOverviewResponse.self,
                endpoint: .overview
            )
            
            return [
                .init(type: .mrr, value: "\(data?.mrr?.formatted(.currency(code: "USD")) ?? "")"),
                .init(type: .subsciptions, value: "\(data?.activeSubscribersCount?.formatted() ?? "")"),
                .init(type: .trials, value: "\(data?.activeTrialsCount?.formatted() ?? "")"),
                .init(type: .revenue, value: "\(data?.revenue?.formatted(.currency(code: "USD")) ?? "")"),
                .init(type: .users, value: "\(data?.activeUsersCount?.formatted() ?? "")"),
                .init(type: .installs, value: "\(data?.installsCount?.formatted() ?? "")")
            ]
        } catch {
            throw error
        }
    }
}
