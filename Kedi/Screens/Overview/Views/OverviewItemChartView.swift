//
//  OverviewItemChartView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import SwiftUI
import Charts

struct OverviewItemChartView: View {
    
    @State var values: [OverviewItemChartValue]
    var foregroundColor: Color = .blue
    
    var body: some View {
        if values.count == 1,
           let value = values.first {
            Chart {
                PointMark(
                    x: .value("Date", value.date),
                    y: .value("Value", value.value)
                )
                .foregroundStyle(foregroundColor)
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .padding(.top)
        } else {
            Chart {
                ForEach(values) { value in
                    LineMark(
                        x: .value("Date", value.date),
                        y: .value("Value", value.value)
                    )
                    .foregroundStyle(foregroundColor)
                    
                    AreaMark(
                        x: .value("Date", value.date),
                        y: .value("Value", value.value)
                    )
                    .foregroundStyle(LinearGradient(
                        gradient: .init(colors: [foregroundColor.opacity(0.5), foregroundColor.opacity(0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                }
                .interpolationMethod(.catmullRom)
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        }
    }
}

#Preview {
    OverviewItemChartView(values: .placeholder)
        .frame(width: 200, height: 200)
}
