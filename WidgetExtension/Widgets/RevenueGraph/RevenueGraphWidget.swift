//
//  RevenueGraphWidget.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/8/24.
//

import SwiftUI
import WidgetKit

struct RevenueGraphWidget: Widget {
    
    let kind = WidgetKind.revenueGraph.rawValue

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RevenueGraphWidgetProvider()) { entry in
            RevenueGraphWidgetView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Revenue Graph")
        .description("Shows an overview of recent transactions.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    RevenueGraphWidget()
} timeline: {
    RevenueGraphWidgetEntry.placeholder
}
