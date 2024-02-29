//
//  OverviewItemChart.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/1/24.
//

import Foundation

struct OverviewItemChart: Hashable {
    
    var chartValues: [LineAndAreaMarkChartValue]
    var updatedAt: String?
    
    var updatedAtFormatted: String? {
        guard let formatted = updatedAt?.format(to: .iso8601WithoutMilliseconds)?.formatted(date: .abbreviated, time: .shortened) else {
            return nil
        }
        return "Updated \(formatted)"
    }
}
