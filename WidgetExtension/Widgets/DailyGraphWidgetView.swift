//
//  DailyGraphWidgetView.swift
//  WidgetExtensionExtension
//
//  Created by Saffet Emin Reisoğlu on 2/8/24.
//

import SwiftUI

struct DailyGraphWidgetView : View {
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: DailyGraphWidgetProvider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            RectangleMarkGraphView(values: entry.items, weekCount: 7)
                .clipShape(ContainerRelativeShape())
        case .systemMedium:
            RectangleMarkGraphView(values: entry.items, weekCount: 17)
                .clipShape(ContainerRelativeShape())
        default:
            Text("Unsupported widget family!")
        }
    }
}

#Preview {
    DailyGraphWidgetView(entry: .placeholder)
}
