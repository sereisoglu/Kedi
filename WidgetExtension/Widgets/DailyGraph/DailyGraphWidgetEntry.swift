//
//  DailyGraphWidgetEntry.swift
//  WidgetExtensionExtension
//
//  Created by Saffet Emin Reisoğlu on 2/8/24.
//

import Foundation
import WidgetKit

struct DailyGraphWidgetEntry: TimelineEntry {
    
    let date: Date
    let items: [RectangleMarkGraphValue]
    var error: RCError?
}

extension DailyGraphWidgetEntry {
    
    static let placeholder: Self = {
        let WEEK_COUNT = 17
        let from = Date(byAdding: .weekOfMonth, value: -(WEEK_COUNT - 1), to: Date().startOfWeek)
        let to = Date()
        let dates = Date.generate(from: from, to: to, isToIncluded: false)
        
        return .init(
            date: Date(),
            items: dates.compactMap { .init(date: $0, value: Double(Int.random(in: 0...10))) }
        )
    }()
}
