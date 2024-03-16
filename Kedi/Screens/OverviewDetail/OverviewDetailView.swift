//
//  OverviewDetailView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/19/24.
//

import SwiftUI
import Charts

struct OverviewDetailView: View {
    
    @State private var selectedItem: OverviewItemCharValue?
    //    @State private var margin: CGFloat = .zero
    
    @StateObject var viewModel: OverviewDetailViewModel
    
    private var item: OverviewItem {
        viewModel.item
    }
    
    private var chartValues: [OverviewItemCharValue] {
        item.chart?.values ?? []
    }
    
    private var title: String {
        if let selectedItem {
            return OverviewItemValue(type: item.type, value: selectedItem.value).formatted
        } else {
            return item.value.formatted
        }
    }
    
    private var subtitle: String {
        if let selectedItem {
            return selectedItem.date.formatted(date: .abbreviated, time: .omitted)
        } else {
            guard let firstDate = chartValues.first?.date,
                  let lastDate = chartValues.last?.date else {
                return " "
            }
            return "\(firstDate.formatted(date: .abbreviated, time: .omitted)) - \(lastDate.formatted(date: .abbreviated, time: .omitted))"
        }
    }
    
    private var maxValue: Double {
        let max = chartValues.map(\.value).max() ?? 0
        return max.ceilToNearest(toNearest)
    }
    
    private var minValue: Double {
        let min = chartValues.map(\.value).min() ?? 0
        return min >= 0 ? 0 : min.floorToNearest(toNearest)
    }
    
    private var toNearest: Double {
        let max = chartValues.map(\.value).max() ?? 0
        return Double(Int(max).size)
    }
    
    private var xValues: [Date] {
        let dates = chartValues.map(\.date)
        return stride(from: 0, to: dates.count, by: Int(dates.count / 3)).map { dates[$0] }
    }
    
    var body: some View {
        List {
            Section {
                VStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        Text(subtitle)
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
                        Picker("Time Period", selection: $viewModel.configSelection.timePeriod) {
                            ForEach(viewModel.configSelection.type.availableTimePeriods, id: \.self) { timePeriod in
                                Text(timePeriod.title)
                                    .textCase(nil)
                            }
                        }
                        .onChange(of: viewModel.configSelection.timePeriod) { oldValue, newValue in
                            viewModel.onTimePeriodChange()
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
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.systemGroupedBackground)
        //        .getSize { size in
        //            let width = min(size.width, 500)
        //            margin = (size.width - width) / 2
        //        }
        //        .if(margin > 0) { view in
        //            view.contentMargins(.horizontal, margin, for: .scrollContent)
        //        }
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
                
                if selectedItem == value {
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
        .chartXScale(domain: (chartValues.first?.date ?? .now)...(chartValues.last?.date ?? .now))
        .chartXAxis { AxisMarks(values: xValues) }
        .chartYScale(domain: minValue...maxValue)
        .chartGesture { proxy in
            DragGesture()
                .onChanged { value in
                    guard let date: Date = proxy.value(atX: value.location.x) else {
                        return
                    }
                    let timestamp = date.timeIntervalSince1970
                    if let item = chartValues.min(by: { abs($0.date.timeIntervalSince1970 - timestamp) < abs($1.date.timeIntervalSince1970 - timestamp) }) {
                        selectedItem = item
                    }
                }
                .onEnded { value in
                    selectedItem = nil
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
