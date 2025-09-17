//
//  PaydayScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/25/24.
//

import SwiftUI

struct PaydayScreen: View {
    
    @StateObject private var viewModel = PaydayViewModel()
    
    @ScaledMetric private var emojiWidth: CGFloat = 30
    @Environment(\.dismiss) private var dismiss
    
    var isPresented = false
    
    var body: some View {
        List {
            if let payday = viewModel.upcomingPayday {
                Section {
                    switch payday.state {
                    case .today:
                        makeItem(
                            emoji: payday.emoji,
                            title: "It’s payday!",
                            subtitle: "\(payday.fiscalMonthFormatted) (\(payday.startDateFormatted) - \(payday.endDateFormatted))"
                        )
                    case .tomorrow:
                        makeItemWithTimer(
                            emoji: payday.emoji,
                            date: payday.paymentDate,
                            subtitle: "\(payday.fiscalMonthFormatted) (\(payday.startDateFormatted) - \(payday.endDateFormatted))"
                        )
                    case .upcoming,
                            .future,
                            .past:
                        makeItem(
                            emoji: payday.emoji,
                            title: "\(payday.paymentDateRelativeFormatted) – \(payday.paymentDateFormatted)",
                            subtitle: "\(payday.fiscalMonthFormatted) (\(payday.startDateFormatted) - \(payday.endDateFormatted))"
                        )
                    }
                } header: {
                    Text(payday.state.title)
                } footer: {
                    Text("Earnings from the \(payday.fiscalMonthFormatted) fiscal month will be deposited \(payday.paymentDateFormatted).")
                }
            }
            
            ForEach(Array(viewModel.sortedYears), id: \.self) { year in
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
            if isPresented {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .safeClose) {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    BrowserUtility.openUrlInApp(urlString: "https://www.revenuecat.com/blog/growth/apple-fiscal-calendar-year-payment-dates")
                } label: {
                    Image(systemName: "info.circle")
                }
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
                withOptionalAnimation {
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
        PaydayScreen()
    }
}
