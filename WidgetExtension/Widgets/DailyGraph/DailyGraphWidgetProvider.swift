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
                    policy = .after(Date(byAdding: .minute, value: 1))
                } else {
                    policy = .after(Date(byAdding: .minute, value: 20))
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
            if retryCount > 0 {
                await getEntry(context: context, retryCount: retryCount - 1, completion: completion)
                return
            }
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
        if Endpoint.AUTH_TOKEN == nil {
            SessionManager.shared.startWidgetExtension()
            apiService.setAuthToken(SessionManager.shared.getRevenueCatCookie()?.value)
        }
        
        do {
            let data = try await apiService.request(
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
