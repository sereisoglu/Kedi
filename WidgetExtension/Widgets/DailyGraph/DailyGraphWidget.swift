//
//  DailyGraphWidget.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/8/24.
//

import SwiftUI
import WidgetKit

struct DailyGraphWidget: Widget {
    
    let kind = WidgetKind.dailyGraph.rawValue

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyGraphWidgetProvider()) { entry in
            DailyGraphWidgetView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Daily Graph")
        .description("Shows an overview of recent transactions.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    DailyGraphWidget()
} timeline: {
    DailyGraphWidgetEntry.placeholder
}
