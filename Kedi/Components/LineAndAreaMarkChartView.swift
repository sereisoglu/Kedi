//
//  LineAndAreaMarkChartView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import SwiftUI
import Charts

struct LineAndAreaMarkChartValue: Identifiable, Hashable {
    
    var id: Int { Int(date.timeIntervalSince1970) }
    let date: Date
    let value: Double
}

@available(iOS 16, *)
struct LineAndAreaMarkChartView: View {
    
    @State var values: [LineAndAreaMarkChartValue]
    var foregroundColor: Color = .blue
    
    var body: some View {
        Chart {
            ForEach(values) { value in
                LineMark(
                    x: .value("Date", value.date),
                    y: .value("Value", value.value)
                )
            }
            .interpolationMethod(.cardinal)
            .foregroundStyle(foregroundColor)
            
            ForEach(values) { value in
                AreaMark(
                    x: .value("Date", value.date),
                    y: .value("Value", value.value)
                )
            }
            .interpolationMethod(.cardinal)
            .foregroundStyle(LinearGradient(
                gradient: .init(colors: [foregroundColor.opacity(0.5), foregroundColor.opacity(0)]),
                startPoint: .top,
                endPoint: .bottom
            ))
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

#Preview {
    LineAndAreaMarkChartView(values: [])
}
