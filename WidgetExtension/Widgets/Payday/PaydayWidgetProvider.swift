//
//  PaydayWidgetProvider.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/25/24.
//

import Foundation
import WidgetKit

struct PaydayWidgetProvider: TimelineProvider {
    
    private let secondGranularity: Double = 3600 // 60 * 60 // 1 hour
    
    typealias Entry = PaydayWidgetEntry
    
    func placeholder(in context: Context) -> Entry {
        .placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        completion(.placeholder)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        guard let payday = AppStorePayday.upcomingPayday else {
            completion(.init(entries: [.placeholder], policy: .after(Date().nearestDate(secondGranularity: secondGranularity))))
            return
        }
        
        let entries: [Entry]
        switch payday.state {
        case .today:
            if let nextPayday = AppStorePayday.nextToUpcomingPayday {
                entries = [
                    Entry(date: .now, state: .today, paymentDate: payday.paymentDate),
                    Entry(date: nextPayday.paymentDate, state: .upcoming, paymentDate: nextPayday.paymentDate)
                ]
            } else {
                entries = [
                    Entry(date: .now, state: .today, paymentDate: payday.paymentDate)
                ]
            }
        case .tomorrow:
            entries = [
                Entry(date: .now, state: .tomorrow, paymentDate: payday.paymentDate),
                Entry(date: payday.paymentDate, state: .today, paymentDate: payday.paymentDate)
            ]
        case .upcoming:
            entries = [
                Entry(date: .now,  state: .upcoming, paymentDate: payday.paymentDate),
                Entry(date: payday.paymentDate.byAdding(.day, value: -1),  state: .tomorrow, paymentDate: payday.paymentDate),
                Entry(date: payday.paymentDate, state: .today, paymentDate: payday.paymentDate)
            ]
        case .future,
                .past:
            completion(.init(entries: [.placeholder], policy: .after(Date().nearestDate(secondGranularity: secondGranularity))))
            return
        }
        
        completion(.init(entries: entries, policy: .after(Date().nearestDate(secondGranularity: secondGranularity))))
    }
}
