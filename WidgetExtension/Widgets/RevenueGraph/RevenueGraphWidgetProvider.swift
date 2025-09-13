//
//  RevenueGraphWidgetProvider.swift
//  WidgetExtensionExtension
//
//  Created by Saffet Emin Reisoğlu on 2/8/24.
//

import Foundation
import WidgetKit

struct RevenueGraphWidgetProvider: TimelineProvider {
    
    typealias Entry = RevenueGraphWidgetEntry
    
    private let apiService = APIService.shared
    private let authManager = AuthManager.shared
    private let sessionManager = SessionManager.shared
    private let cacheService = CacheService.shared
    
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
                switch entry.error {
                case .unauthorized:
                    policy = .after(Date().byAdding(.minute, value: 15))
                case .service:
                    policy = .after(Date().byAdding(.minute, value: 2))
                case .none: // success
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
        sessionManager.startWidgetExtension()
        guard let authToken = authManager.getAuthToken() else {
            completion(.init(date: .now, items: [], error: .unauthorized))
            return
        }
        apiService.setAuthToken(authToken)
        
        var items = [RectangleMarkGraphValue]()
        var err: WidgetError?
        do {
            items = try await fetchData()
            cacheService.set(
                "widgets/revenueGraph",
                data: items,
                expiry: .date(Date().byAdding(.day, value: 1))
            )
        } catch {
            if retryCount > 0 {
                await getEntry(context: context, retryCount: retryCount - 1, completion: completion)
                return
            }
            err = .service(error as? RCError ?? .internal(.error(error)))
            items = (cacheService.get("widgets/revenueGraph") as [RectangleMarkGraphValue]?) ?? []
        }
        
        if context.isPreview,
           err != nil {
            completion(.placeholder)
        } else {
            completion(.init(date: .now, items: items, error: err))
        }
    }
    
    private func fetchData() async throws -> [RectangleMarkGraphValue] {
        do {
            let data = try await apiService.request(
                .charts(
                    name: .revenue,
                    .init(
                        resolution: .day,
                        startDate: Date().byAdding(.weekOfYear, value: -18).format(to: .yyy_MM_dd),
                        revenueType: .revenue
                    )
                )
            ) as RCChartResponse
            return data.values?.map {
                .init(
                    date: .init(timeIntervalSince1970: Double($0.cohort ?? 0)).startOfDay,
                    value: $0.value ?? 0
                )
            } ?? []
        } catch {
            throw error
        }
    }
}
