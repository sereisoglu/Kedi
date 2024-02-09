//
//  RectangleMarkGraphView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI
import Charts

struct RectangleMarkGraphView: View {
    
    static let INSET: CGFloat = 2
    static let CORNER_RADIUS: CGFloat = 2
    
    private let dates: [Date]
    private let data: RectangleMarkGraphModel
    private let median: Double
    
    init(values: [RectangleMarkGraphValue], weekCount: Int = 17) {
        dates = Self.getDates(weekCount: weekCount)
        data = values.keyBy(\.date)
        median = values.compactMap { Double($0.count) }.median() ?? 0
    }
    
    var body: some View {
        Chart(dates, id: \.self) { date in
            let count = data[date]?.count
            let relativeWeek = relativeWeek(from: dates.first ?? date, to: date)
            
            RectangleMark(
                xStart: .value("xStart", relativeWeek),
                xEnd: .value("xEnd", relativeWeek + 1),
                yStart: .value("yStart", date.weekday - 1),
                yEnd: .value("yEnd", date.weekday)
            )
            .clipShape(InsettableRectangle(inset: Self.INSET, cornerRadius: Self.CORNER_RADIUS))
            .foregroundStyle(getColor(date: date, count: count, median: median))
        }
        .chartYAxis(.hidden)
        .chartXAxis(.hidden)
        .chartLegend(.hidden)
        .chartYScale(domain: .automatic(reversed: true))
        .padding(-Self.INSET)
    }
    
    private static func getDates(weekCount: Int) -> [Date] {
        let from = Date(byAdding: .weekOfMonth, value: -(weekCount - 1), to: Date().startOfWeek)
        let to = Date(byAdding: .weekOfMonth, value: 1, to: Date().startOfWeek)
        return Date.generate(from: from, to: to, isToIncluded: false)
    }
    
    private func relativeWeek(from: Date, to: Date) -> Int {
        let daysApart = Calendar.current.dateComponents([.day], from: from, to: to).day ?? 0
        return daysApart / 7
    }
    
    private func getColor(date: Date, count: Int?, median: Double) -> Color {
        if date.isFuture {
            return .clear
        }
        
        if (count ?? 0) == 0 {
            return .gray.opacity(0.25) // .quaternaryLabel
        }
        
        var opacity = min(Double(count ?? 0) / (2 * median), 1)
        opacity = ceil(opacity / 0.1) * 0.1
        return .accentColor.opacity(opacity)
    }
}

#Preview {
    RectangleMarkGraphView(values: [])
}
