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
        let dates = RectangleMarkGraphView.getDates(weekCount: 17)
        return .init(
            date: Date(),
            items: dates.map { .init(date: $0, value: Double(Int.random(in: 0...10))) }
        )
    }()
}
