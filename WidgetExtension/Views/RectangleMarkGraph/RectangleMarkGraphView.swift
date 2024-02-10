//
//  RectangleMarkGraphView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI
import Charts

// https://github.com/jordibruin/Swift-Charts-Examples/blob/main/Swift%20Charts%20Examples/Charts/HeatMap/GitHubContributionsGraph.swift
struct RectangleMarkGraphView: View {
    
    static let INSET: CGFloat = 2
    static let CORNER_RADIUS: CGFloat = 2
    
    private let dates: [Date]
    private let data: RectangleMarkGraphModel
    private let median: Double
    
    init(values: [RectangleMarkGraphValue], weekCount: Int = 17) {
        dates = Self.getDates(weekCount: weekCount)
        data = values.keyBy(\.date)
        median = values.compactMap { $0.value }.median() ?? 0
    }
    
    var body: some View {
        Chart(dates, id: \.self) { date in
            let value = data[date]?.value
            let relativeWeek = relativeWeek(from: dates.first ?? date, to: date)
            
            RectangleMark(
                xStart: .value("xStart", relativeWeek),
                xEnd: .value("xEnd", relativeWeek + 1),
                yStart: .value("yStart", date.weekday - 1),
                yEnd: .value("yEnd", date.weekday)
            )
            .clipShape(InsettableRectangle(inset: Self.INSET, cornerRadius: Self.CORNER_RADIUS))
            .foregroundStyle(getColor(date: date, value: value, median: median))
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
    
    private func getColor(date: Date, value: Double?, median: Double) -> Color {
        if date.isFuture {
            return .clear
        }
        
        guard let value,
              value != 0 else {
            return .gray.opacity(0.25) // .quaternaryLabel
        }
        
        var opacity = min(value / (2 * median), 1)
        opacity = ceil(opacity / 0.1) * 0.1
        return .accentColor.opacity(opacity)
    }
}

#Preview {
    RectangleMarkGraphView(values: [])
}
