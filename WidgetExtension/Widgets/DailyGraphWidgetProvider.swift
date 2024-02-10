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
    
    let authManager = AuthManager.shared
    let apiManager = APIService.shared
    
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
                let policy: TimelineReloadPolicy = .after(Date().nearestQuarterHourToTheFuture())
                let timeline = Timeline(entries: [entry], policy: policy)
                completion(timeline)
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
        } catch {
            err = error as? RCError
        }
        
        if err != nil,
           context.isPreview {
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
