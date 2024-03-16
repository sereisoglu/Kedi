//
//  OverviewItemChart.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/1/24.
//

import Foundation

struct OverviewItemChart: Hashable {
    
    var values: [OverviewItemChartValue]
    var updatedAt: String?
    
    var updatedAtFormatted: String? {
        guard let formatted = updatedAt?.format(to: .iso8601WithoutMilliseconds)?.formatted(date: .abbreviated, time: .shortened) else {
            return nil
        }
        return "Updated \(formatted)"
    }
}

struct OverviewItemChartValue: Identifiable, Hashable {
    
    var id: Int { Int(date.timeIntervalSince1970) }
    let date: Date
    let value: Double
}

extension Array where Element == OverviewItemChartValue {
    
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
