//
//  DailyGraphWidgetProvider.swift
//  WidgetExtensionExtension
//
//  Created by Saffet Emin Reisoğlu on 2/8/24.
//

import Foundation
import WidgetKit

struct DailyGraphWidgetProvider: TimelineProvider {
    
    typealias Entry = DailyGraphWidgetEntry
    
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
        var items = [RectangleMarkGraphValue]()
        var err: RCError?
        do {
            items = try await fetchData()
            cacheManager.setWithEncode(
                key: "widgets/dailyGraph",
                data: items,
                expiry: .date(.init(byAdding: .day, value: 3))
            )
        } catch {
            err = error as? RCError
            items = cacheManager.getWithDecode(
                key: "widgets/dailyGraph",
                type: [RectangleMarkGraphValue].self
            ) ?? []
        }
        
        if context.isPreview,
           err != nil {
            completion(.placeholder)
        } else {
            completion(.init(date: Date(), items: items, error: err))
        }
    }
    
    private func fetchData() async throws -> [RectangleMarkGraphValue] {
        do {
            let data = try await apiManager.request(
                type: RCChartResponse.self,
                endpoint: .charts(.init(
                    name: .revenue,
                    resolution: .day,
                    startDate: Date(byAdding: .month, value: -4).format(to: .yyy_MM_dd)
                ))
            )
            
            return data?.values?.map {
                .init(
                    date: .init(timeIntervalSince1970: $0[safe: 0] ?? 0).getHourTo0,
                    value: $0[safe: 3] ?? 0
                )
            } ?? []
        } catch {
            throw error
        }
    }
}
