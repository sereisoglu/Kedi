//
//  OverviewWidget.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/10/24.
//

import SwiftUI
import WidgetKit

struct OverviewWidget: Widget {
    
    let kind = WidgetKind.overview.rawValue

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OverviewWidgetProvider()) { entry in
            OverviewWidgetView(entry: entry)
                .containerBackground(.clear, for: .widget)
                .widgetAccentable()
        }
        .configurationDisplayName("Overview")
        .description("Shows an overview of your stats.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    OverviewWidget()
} timeline: {
    OverviewWidgetEntry.placeholder
}
