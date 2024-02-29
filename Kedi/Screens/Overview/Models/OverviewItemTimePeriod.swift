//
//  OverviewItemTimePeriod.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import Foundation

enum OverviewItemTimePeriod: String, CaseIterable, Codable {
    
    case last7Days
    case last28Days
    case last30Days
    case last90Days
    case last12Months
    case lastWeek
    case lastMonth
    case lastYear
    case thisWeek
    case thisMonth
    case thisYear
    case allTime
    
    var title: String {
        switch self {
        case .last7Days: "Last 7 days"
        case .last28Days: "Last 28 days"
        case .last30Days: "Last 30 days"
        case .last90Days: "Last 90 days"
        case .last12Months: "Last 12 months"
        case .lastWeek: "Last week"
        case .lastMonth: "Last month"
        case .lastYear: "Last year"
        case .thisWeek: "This week"
        case .thisMonth: "This month"
        case .thisYear: "This year"
        case .allTime: "All-time"
        }
    }
    
    var startDate: String? {
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        
        var date: Date
        switch self {
        case .last7Days:
            date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            date = calendar.date(byAdding: .day, value: -7, to: date) ?? Date()
        case .last28Days:
            date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            date = calendar.date(byAdding: .day, value: -28, to: date) ?? Date()
        case .last30Days:
            date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            date = calendar.date(byAdding: .day, value: -30, to: date) ?? Date()
        case .last90Days:
            date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            date = calendar.date(byAdding: .day, value: -90, to: date) ?? Date()
        case .last12Months:
            date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
            date = calendar.date(byAdding: .month, value: -12, to: date) ?? Date()
        case .lastWeek:
            date = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
            date = calendar.date(byAdding: .weekOfYear, value: -1, to: date) ?? Date()
        case .lastMonth:
            date = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
            date = calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
        case .lastYear:
            date = calendar.date(from: calendar.dateComponents([.year], from: Date())) ?? Date()
            date = calendar.date(byAdding: .year, value: -1, to: date) ?? Date()
        case .thisWeek:
            date = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        case .thisMonth:
            date = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
        case .thisYear:
            date = calendar.date(from: calendar.dateComponents([.year], from: Date())) ?? Date()
        case .allTime:
            return nil
        }
        
        return DateFormatter.yyy_MM_dd_GMT.string(from: date)
    }
    
    var endDate: String? {
        var calendar = Calendar.current
        calendar.timeZone = .gmt
        
        var date: Date
        switch self {
        case .last7Days,
                .last28Days,
                .last30Days,
                .last90Days,
                .last12Months,
                .thisWeek,
                .thisMonth,
                .thisYear,
                .allTime:
            date = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: Date())) ?? Date()
        case .lastWeek:
            date = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
            date = calendar.date(byAdding: .day, value: -1, to: date) ?? Date()
        case .lastMonth:
            date = calendar.date(from: calendar.dateComponents([.year, .month], from: Date())) ?? Date()
            date = calendar.date(byAdding: .day, value: -1, to: date) ?? Date()
        case .lastYear:
            date = calendar.date(from: calendar.dateComponents([.year], from: Date())) ?? Date()
            date = calendar.date(byAdding: .day, value: -1, to: date) ?? Date()
        }
        
        return DateFormatter.yyy_MM_dd_GMT.string(from: date)
    }
    
    var resolution: RCChartResolution {
        switch self {
        case .last7Days: .day
        case .last28Days: .day
        case .last30Days: .day
        case .last90Days: .week
        case .last12Months: .month
        case .lastWeek: .day
        case .lastMonth: .day
        case .lastYear: .month
        case .thisWeek: .day
        case .thisMonth: .day
        case .thisYear: .month
        case .allTime: .month
        }
    }
    
    var resolutionTitle: String {
        switch resolution {
        case .day: "Today"
        case .week: "This week"
        case .month: "This month"
        case .quarter: "This quarter"
        case .year: "This year"
        }
    }
}
