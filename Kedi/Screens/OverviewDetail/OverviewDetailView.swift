//
//  OverviewDetailView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/19/24.
//

import SwiftUI
import Charts

struct OverviewDetailView: View {
    
    @State private var infoHeight: CGFloat = .zero
    
    @StateObject var viewModel: OverviewDetailViewModel
    
    var body: some View {
        List {
            Section {
                VStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.item.value.formatted)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        if let subtitle = viewModel.item.subtitle {
                            Text(subtitle)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Chart {
                        ForEach(viewModel.item.chart?.chartValues ?? []) { value in
                            LineMark(
                                x: .value("Date", value.date),
                                y: .value("Value", value.value)
                            )
                        }
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.blue)
                        
                        ForEach(viewModel.item.chart?.chartValues ?? []) { value in
                            AreaMark(
                                x: .value("Date", value.date),
                                y: .value("Value", value.value)
                            )
                        }
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(LinearGradient(
                            gradient: .init(colors: [Color.blue.opacity(0.5), Color.blue.opacity(0)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    }
                    .frame(height: 120)
                }
            } header: {
                HStack {
                    Label(viewModel.item.title, systemImage: viewModel.item.icon)
                    
                    Spacer()
                    
                    Menu {
                        Picker("Time Period", selection: $viewModel.configSelection.timePeriod) {
                            ForEach(viewModel.configSelection.type.availableTimePeriods, id: \.self) { timePeriod in
                                Text(timePeriod.title)
                                    .textCase(nil)
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.configSelection.timePeriod.title)
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .font(.footnote)
                        .textCase(nil)
                    }
                }
            } footer: {
                Text(viewModel.item.caption ?? "")
            }
//            .listRowInsets(.zero)
            
            Section {
                ForEach(Array((viewModel.item.chart?.chartValues ?? []).reversed().enumerated()), id: \.offset) { index, value in
                    HStack {
                        Text(OverviewItemValue(type: viewModel.item.type, value: value.value).formatted)
                            .font(.callout)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Text(value.date.formatted(date: .abbreviated, time: .omitted))
                            .foregroundStyle(.secondary)
                            .font(.callout)
                    }
                }
            }
        }
        .navigationTitle(viewModel.item.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.systemGroupedBackground)
    }
}

#Preview {
    NavigationStack {
        OverviewDetailView(viewModel: .init(item: .init(
            config: .init(type: .mrr, timePeriod: .allTime),
            value: .mrr(1234.23),
            valueState: .data,
            chart: .init(chartValues: .placeholder)
        )))
    }
}
