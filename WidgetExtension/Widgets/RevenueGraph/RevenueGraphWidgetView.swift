//
//  RevenueGraphWidgetView.swift
//  WidgetExtensionExtension
//
//  Created by Saffet Emin Reisoğlu on 2/8/24.
//

import SwiftUI

struct RevenueGraphWidgetView: View {
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var entry: RevenueGraphWidgetProvider.Entry
    
    var body: some View {
        if let error = entry.error,
           entry.items.isEmpty {
            WidgetErrorView(error: error)
                .padding()
        } else {
            makeWidgetView()
        }
    }
    
    private func makeWidgetView() -> some View {
        ZStack {
            switch widgetFamily {
            case .systemSmall:
                RectangleMarkGraphView(values: entry.items, weekCount: 7)
                    .clipShape(ContainerRelativeShape())
                    .padding()
            case .systemMedium:
                RectangleMarkGraphView(values: entry.items, weekCount: 17)
                    .clipShape(ContainerRelativeShape())
                    .padding()
            default:
                Text("Unsupported widget family!")
            }
            
            if let message = entry.error?.localizedDescription {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .dynamicTypeSize(DynamicTypeSize.large)
                }
                .padding(.horizontal)
                .padding(.bottom, 2)
            }
        }
    }
}

#Preview {
    RevenueGraphWidgetView(entry: .placeholder)
}
