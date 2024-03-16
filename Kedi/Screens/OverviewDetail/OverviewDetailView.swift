//
//  OverviewDetailView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/19/24.
//

import SwiftUI
import Charts

struct OverviewDetailView: View {
    
    //    @State private var margin: CGFloat = .zero
    
    @StateObject var viewModel: OverviewDetailViewModel
    
    private var item: OverviewItem {
        viewModel.item
    }
    
    private var chartValues: [OverviewItemChartValue] {
        viewModel.chartValues
    }
    
    var body: some View {
        makeBody()
            .navigationTitle(item.title)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.systemGroupedBackground)
        //            .getSize { size in
        //                let width = min(size.width, 500)
        //                margin = (size.width - width) / 2
        //            }
        //            .if(margin > 0) { view in
        //                view.contentMargins(.horizontal, margin, for: .scrollContent)
        //            }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty:
            ContentUnavailableView(
                "No Data",
                systemImage: "xmark.circle"
            )
            
        case .error(let error):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(error.localizedDescription)
            )
            
        case .data:
            List {
                Section {
                    VStack {
                        VStack(alignment: .leading) {
                            Text(viewModel.title)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Text(viewModel.subtitle)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        makeChart()
                    }
                    .frame(height: 200)
                } header: {
                    HStack {
                        Label(item.title, systemImage: item.icon)
                        
                        Spacer()
                        
                        Menu {
                            Picker("Time Period", selection: $viewModel.timePeriodSelection) {
                                ForEach(item.type.availableTimePeriods, id: \.self) { timePeriod in
                                    Text(timePeriod.title)
                                        .textCase(nil)
                                }
                            }
                            .onChange(of: viewModel.timePeriodSelection) { oldValue, newValue in
                                if oldValue != newValue {
                                    viewModel.onTimePeriodChange()
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.timePeriodSelection.title)
                                Image(systemName: "chevron.up.chevron.down")
                            }
                            .font(.footnote)
                            .textCase(nil)
                        }
                    }
                }
                
                Section {
                    ForEach(Array(chartValues.reversed().enumerated()), id: \.offset) { index, value in
                        HStack {
                            Text(OverviewItemValue(type: item.type, value: value.value).formatted)
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
        }
    }
    
    private func makeChart() -> some View {
        Chart {
            ForEach(chartValues) { value in
                LineMark(
                    x: .value("Date", value.date),
                    y: .value("Value", value.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.blue)
                
                AreaMark(
                    x: .value("Date", value.date),
                    y: .value("Value", value.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(LinearGradient(
                    gradient: .init(colors: [Color.blue.opacity(0.5), Color.blue.opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                
                if viewModel.selectedChartValue == value {
                    RuleMark(x: .value("Selected Date", value.date))
                    //                        .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                    //                            VStack(spacing: 0) {
                    //                                Text(OverviewItemValue(type: item.type, value: value.value).formatted)
                    //                                    .font(.footnote)
                    //                                    .bold()
                    //                                    .foregroundStyle(Color.accentColor)
                    //
                    //                                Text(value.date.formatted(date: .abbreviated, time: .omitted))
                    //                                    .font(.caption2)
                    //                                    .foregroundStyle(.secondary)
                    //                            }
                    //                        }
                    
                    PointMark(
                        x: .value("Selected Date", value.date),
                        y: .value("Selected Value", value.value)
                    )
                    .annotation(position: .overlay, alignment: .center) {
                        Circle()
                            .stroke(Color.secondarySystemGroupedBackground, lineWidth: 5)
                            .fill(Color.accentColor)
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .chartXScale(domain: viewModel.chartXScale)
        .chartXAxis { AxisMarks(values: viewModel.chartXValues) }
        .chartYScale(domain: viewModel.chartYScale)
        .chartGesture { proxy in
            DragGesture()
                .onChanged { value in
                    guard let date: Date = proxy.value(atX: value.location.x) else {
                        return
                    }
                    let timestamp = date.timeIntervalSince1970
                    if let item = chartValues.min(by: { abs($0.date.timeIntervalSince1970 - timestamp) < abs($1.date.timeIntervalSince1970 - timestamp) }) {
                        viewModel.selectedChartValue = item
                    }
                }
                .onEnded { value in
                    viewModel.selectedChartValue = nil
                }
        }
    }
}

#Preview {
    NavigationStack {
        OverviewDetailView(viewModel: .init(item: .init(
            config: .init(type: .mrr, timePeriod: .allTime),
            value: .mrr(1234.23),
            valueState: .data,
            chart: .init(values: .placeholder)
        )))
    }
}
