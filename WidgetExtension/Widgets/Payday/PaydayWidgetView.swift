//
//  PaydayWidgetView.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/25/24.
//

import SwiftUI

struct PaydayWidgetView: View {
    
    var entry: PaydayWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .center) {
            Text("APP STORE PAYDAY")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer()
            
            if let paymentDate = entry.paymentDate,
               let paymentDateFormatted = entry.paymentDateFormatted,
               let paymentDateRelativeFormatted = entry.paymentDateRelativeFormatted {
                switch entry.state {
                case .today:
                    makeItem(
                        emoji: entry.state.emoji,
                        title: "It’s payday!"
                    )
                case .tomorrow:
                    makeItemWithTimer(
                        emoji: entry.state.emoji,
                        date: paymentDate
                    )
                case .upcoming,
                        .future,
                        .past:
                    makeItem(
                        emoji: entry.state.emoji,
                        title: paymentDateRelativeFormatted
                    )
                }
                
                Spacer()
                
                Text(paymentDateFormatted)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.primary.opacity(0.1))
                    .clipShape(Capsule())
            } else {
                makeItem(
                    emoji: "‼️",
                    title: "Not Found"
                )
                
                Spacer()
            }
        }
        .padding()
        .widgetURL(DeepLink.make(host: .payday))
    }
    
    private func makeItem(emoji: String, title: String) -> some View {
        VStack(alignment: .center, spacing: 2) {
            Text(emoji)
                .font(.title)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
    }
    
    private func makeItemWithTimer(emoji: String, date: Date) -> some View {
        VStack(alignment: .center, spacing: 2) {
            Text(emoji)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text(date, style: .timer)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .monospacedDigit()
                .contentTransition(.numericText(countsDown: true))
        }
    }
}

#Preview {
    PaydayWidgetView(entry: .placeholder)
}
