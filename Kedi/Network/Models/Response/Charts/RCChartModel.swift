//
//  RCChartModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

typealias RCChartValue = [Double]

struct RCChartModel: Decodable {
    
    var type: RCChartType? { documentationLink?.type }
    
    var documentationLink: RCChartDocumentationLink?
    var values: [RCChartValue]?
    
    enum CodingKeys: String, CodingKey {
        case documentationLink = "documentation_link"
        case values = "values"
    }
}

enum RCChartDocumentationLink: String, Decodable {
    
    case mrr = "monthly-recurring-revenue-mrr-chart"
    case actives = "active-subscriptions-chart"
    case revenue = "revenue-chart"
    case trials = "active-trials-chart"
    
    var type: RCChartType {
        switch self {
        case .mrr: .mrr
        case .actives: .actives
        case .revenue: .revenue
        case .trials: .trials
        }
    }
}
