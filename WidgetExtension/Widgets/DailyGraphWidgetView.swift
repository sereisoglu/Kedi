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
        ZStack {
            switch widgetFamily {
            case .systemSmall:
                RectangleMarkGraphView(values: entry.items, weekCount: 7)
                    .padding()
                    .clipShape(ContainerRelativeShape())
            case .systemMedium:
                RectangleMarkGraphView(values: entry.items, weekCount: 17)
                    .padding()
                    .clipShape(ContainerRelativeShape())
            default:
                Text("Unsupported widget family!")
            }
            
            if let message = entry.error?.message {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
                .padding(.horizontal)
                .padding(.bottom, 2)
            }
        }
    }
}

#Preview {
    DailyGraphWidgetView(entry: .placeholder)
}
