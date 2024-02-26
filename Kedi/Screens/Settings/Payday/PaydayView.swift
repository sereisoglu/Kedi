//
//  PaydayView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/25/24.
//

import SwiftUI

struct PaydayView: View {
    
    @StateObject private var viewModel = PaydayViewModel()
    
    @ScaledMetric private var emojiWidth: CGFloat = 30
    
    var body: some View {
        List {
            if let payday = viewModel.upcomingPayday {
                Section {
                    if payday.isPaymentDateToday {
                        makeItem(
                            emoji: payday.emoji,
                            title: "It’s payday!",
                            subtitle: "\(payday.fiscalMonthFormatted) (\(payday.startDateFormatted) - \(payday.endDateFormatted))"
                        )
                    } else if payday.isPaymentDateTomorrow {
                        makeItemWithTimer(
                            emoji: payday.emoji,
                            date: payday.paymentDate,
                            subtitle: "\(payday.fiscalMonthFormatted) (\(payday.startDateFormatted) - \(payday.endDateFormatted))"
                        )
                    } else {
                        makeItem(
                            emoji: payday.emoji,
                            title: "\(payday.paymentDateRelativeFormatted) – \(payday.paymentDateFormatted)",
                            subtitle: "\(payday.fiscalMonthFormatted) (\(payday.startDateFormatted) - \(payday.endDateFormatted))"
                        )
                    }
                } header: {
                    Text("Upcoming")
                } footer: {
                    Text("Earnings from the \(payday.fiscalMonthFormatted) fiscal month will be deposited \(payday.paymentDateFormatted).")
                }
            }
            
            ForEach(Array(viewModel.paydays.keys.sorted()), id: \.self) { year in
                Section {
                    ForEach(viewModel.paydays[year] ?? []) { payday in
                        makeItem(
                            emoji: payday.emoji,
                            title: payday.paymentDateFormatted,
                            subtitle: "\(payday.fiscalMonthFormatted) (\(payday.startDateFormatted) - \(payday.endDateFormatted))"
                        )
                    }
                } header: {
                    Text(verbatim: "Apple's Fiscal Year \(year)")
                }
            }
        }
        .navigationTitle("App Store Payday")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                BrowserUtility.openUrlInApp(urlString: "https://www.revenuecat.com/blog/growth/apple-fiscal-calendar-year-payment-dates")
            } label: {
                Image(systemName: "info.circle")
            }
        }
    }
    
    private func makeItem(
        emoji: String,
        title: String,
        subtitle: String
    ) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Text(emoji)
                .frame(width: emojiWidth)
            
            VStack(alignment: .leading) {
                Text(title)
                
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            viewDimensions[.listRowSeparatorLeading] + emojiWidth + 10
        }
    }
    
    private func makeItemWithTimer(
        emoji: String,
        date: Date,
        subtitle: String
    ) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Text(emoji)
                .frame(width: emojiWidth)
            
            VStack(alignment: .leading) {
                withAnimation {
                    Text(date, style: .timer)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }
                
                
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            viewDimensions[.listRowSeparatorLeading] + emojiWidth + 10
        }
    }
}

#Preview {
    NavigationStack {
        PaydayView()
    }
}
