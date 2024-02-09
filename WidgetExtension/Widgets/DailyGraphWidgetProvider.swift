//
//  DailyGraphWidgetProvider.swift
//  WidgetExtensionExtension
//
//  Created by Saffet Emin Reisoğlu on 2/8/24.
//

import Foundation
import WidgetKit

struct DailyGraphWidgetProvider: TimelineProvider {
    
    enum ProviderResult {
        
        case success(items: [RectangleMarkGraphValue])
        case unauthorized
        case failure(items: [RectangleMarkGraphValue], error: Error)
        
        var items: [RectangleMarkGraphValue] {
            switch self {
            case .success(let items):
                return items
            case .unauthorized:
                return []
            case .failure(let items, _):
                return items
            }
        }
        
        var errorString: String? {
            switch self {
            case .success:
                return nil
            case .unauthorized:
                return "unauthorized"
            case .failure(_, let error):
                return error.localizedDescription
            }
        }
    }
    
    typealias Entry = DailyGraphWidgetEntry
    
    let authManager = AuthManager.shared
    
    func placeholder(in context: Context) -> Entry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        Task {
            let items = await fetchData()
            
            getEntry(context: context, result: .success(items: items), completion: completion)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let items = await fetchData()
            
            getEntry(context: context, result: .success(items: items)) { entry in
                let policy: TimelineReloadPolicy = .after(Date().nearestQuarterHourToTheFuture())
                let timeline = Timeline(entries: [entry], policy: policy)
                completion(timeline)
            }
        }
    }
    
    private func getEntry(
        context: Context,
        result: ProviderResult,
        completion: @escaping (Entry) -> Void
    ) {
        if result.errorString != nil,
           context.isPreview {
            completion(.placeholder)
        } else {
            completion(.init(date: Date(), items: result.items))
        }
    }
    
    private func fetchData() async -> [RectangleMarkGraphValue] {
        do {
            let data = try await APIService.shared.request(
                type: RCChartResponse.self,
                endpoint: .charts(.init(name: .revenue, resolution: .day, startDate: "2021-07-15"))// .charts(name: .revenue, resolution: .day, startDate: "2021-07-15")
            )
            
            return data?.values?.map {
                .init(
                    date: .init(timeIntervalSince1970: $0[safe: 0] ?? 0).getHourTo0,
                    count: Int($0[safe: 3] ?? 0)
                )
            } ?? []
        } catch {
            print(error)
            return []
        }
    }
}
