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
                .minimumScaleFactor(0.5)
            
            Spacer()
            
            if let payday = entry.payday {
                switch payday.state {
                case .today:
                    makeItem(
                        emoji: payday.emoji,
                        title: "It’s payday!"
                    )
                    
                case .tomorrow:
                    VStack(alignment: .center, spacing: 2) {
                        Text(payday.emoji)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        
                        Text(payday.paymentDate, style: .timer)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .monospacedDigit()
                            .contentTransition(.numericText(countsDown: true))
                    }
                    
                case .upcoming,
                        .future,
                        .past:
                    makeItem(
                        emoji: payday.emoji,
                        title: payday.paymentDateRelativeFormatted
                    )
                }
                
                Spacer()
                
                Text(payday.paymentDateFormatted)
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
        .dynamicTypeSize(DynamicTypeSize.large)
    }
    
    private func makeItem(emoji: String, title: String) -> some View {
        VStack(alignment: .center, spacing: 2) {
            Text(emoji)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    PaydayWidgetView(entry: .init(date: .now, payday: .upcomingPayday))
}
