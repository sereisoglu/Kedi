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
    
    private let meManager = MeManager.shared
    private let apiService = APIService.shared
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
                if entry.error != nil {
                    policy = .after(Date().byAdding(.minute, value: 2))
                } else {
                    policy = .after(Date().nearestDate(secondGranularity: 60 * 30))
                }
                
                completion(.init(entries: [entry], policy: policy))
            }
        }
    }
    
    private func getEntry(
        context: Context,
        retryCount: Int = 2,
        completion: @escaping (Entry) -> Void
    ) async {
//        guard let authToken = meManager.getAuthToken() else {
//            completion(.placeholder) // TODO: ?
//            return
//        }
//        apiService.setAuthToken(authToken)
        
        var items = [OverviewItem]()
        var err: RCError?
        do {
            items = try await fetchData()
            cacheManager.setWithEncode(
                key: "widgets/overview",
                data: items,
                expiry: .date(Date().byAdding(.day, value: 1))
            )
        } catch {
            if retryCount > 0 {
                await getEntry(context: context, retryCount: retryCount - 1, completion: completion)
                return
            }
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
        if Endpoint.AUTH_TOKEN == nil {
            SessionManager.shared.startWidgetExtension()
            apiService.setAuthToken(SessionManager.shared.getRevenueCatCookie()?.value)
        }
        
        do {
            let data = try await apiService.request(
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
