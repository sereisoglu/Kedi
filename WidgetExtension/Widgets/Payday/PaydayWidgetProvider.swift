//
//  PaydayWidgetProvider.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/25/24.
//

import Foundation
import WidgetKit

struct PaydayWidgetProvider: TimelineProvider {
    
    typealias Entry = PaydayWidgetEntry
    
    func placeholder(in context: Context) -> Entry {
        .init(date: .now, payday: .upcomingPayday)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        completion(.init(date: .now, payday: .upcomingPayday))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        completion(.init(entries: [.init(date: .now, payday: .upcomingPayday)], policy: .atEnd))
    }
}
