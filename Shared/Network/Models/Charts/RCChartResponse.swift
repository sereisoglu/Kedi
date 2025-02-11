//
//  RCChartResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

struct RCChartResponse: Decodable {
    
    var lastComputedAt: String?
    var segments: [RCChartSegment]?
    var summary: [String: [String: Double]]?
    var incompletePeriods: [[Bool]]?
    var values: [RCChartValue]?
    
    enum CodingKeys: String, CodingKey {
        case lastComputedAt = "last_computed_at"
        case segments
        case summary
        case incompletePeriods = "incomplete_periods"
        case values
    }
}

struct RCChartSegment: Decodable {
    
    var chartable: Bool?
    var description: String?
    var displayName: String?
    var tabulable: Bool?
    
    enum CodingKeys: String, CodingKey {
        case chartable
        case description
        case displayName = "display_name"
        case tabulable
    }
}

struct RCChartValue: Decodable {
    
    var cohort: Int?
    //    var incomplete: Bool?
    var measure: Int?
    var value: Double?
}
