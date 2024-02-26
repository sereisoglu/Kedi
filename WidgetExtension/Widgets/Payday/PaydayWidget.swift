//
//  PaydayWidget.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/25/24.
//

import SwiftUI
import WidgetKit

struct PaydayWidget: Widget {
    
    let kind = WidgetKind.payday.rawValue

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PaydayWidgetProvider()) { entry in
            PaydayWidgetView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("App Store Payday")
        .description("Find out when you'll get paid from the App Store.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    PaydayWidget()
} timeline: {
    PaydayWidgetEntry(date: .now, payday: .upcomingPayday)
}
