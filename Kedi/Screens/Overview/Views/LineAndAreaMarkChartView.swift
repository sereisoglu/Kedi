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

extension Array where Element == LineAndAreaMarkChartValue {
    
    static let placeholder: Self = {
        let values = [257.0, 338.0, 309.0, 374.0, 335.0, 566.0, 591.0, 562.0, 593.0, 630.0, 725.0, 706.0, 737.0, 692.0, 663.0, 784.0, 846.0, 1019.0, 972.0, 914.0, 942.0, 950.0, 981.0, 985.0, 986.0, 964.0, 898.0, 895.0, 842.0, 814.0, 1140.0, 1021.0]
        let from = Date().byAdding(.day, value: -values.count)
        let to = Date()
        let dates = Date.generate(from: from, to: to, isToIncluded: false)
        return dates.enumerated().map { index, date in
                .init(date: date, value: values[index])
        }
    }()
}

@available(iOS 16, *)
struct LineAndAreaMarkChartView: View {
    
    @State var values: [LineAndAreaMarkChartValue]
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
                }
                .interpolationMethod(.catmullRom)
                .foregroundStyle(foregroundColor)
                
                ForEach(values) { value in
                    AreaMark(
                        x: .value("Date", value.date),
                        y: .value("Value", value.value)
                    )
                }
                .interpolationMethod(.catmullRom)
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
}

#Preview {
    LineAndAreaMarkChartView(values: .placeholder)
        .frame(width: 200, height: 200)
}
