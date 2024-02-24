//
//  OverviewItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

struct OverviewItem: Identifiable, Hashable {
    
    var id: String { type.rawValue }
    var type: OverviewItemType { value.type }
    var icon: String { type.icon }
    var name: String { type.name }
    var note: String? {
        switch type {
        case .mrr,
                .subsciptions,
                .trials,
                .arr:
            return "\(config.timePeriod.title) (graph)"
        default:
            return config.timePeriod.title
        }
    }
    
    var value: OverviewItemValue
    var chartValues: [LineAndAreaMarkChartValue]?
    var config: OverviewItemConfig
    var isRedacted = true
    
    mutating func set(value: OverviewItemValue) {
        self.value = value
        isRedacted = false
    }
    
    mutating func set(value: OverviewItemValue, chartValues: [LineAndAreaMarkChartValue]?) {
        self.value = value
        self.chartValues = chartValues
        isRedacted = false
    }
}

extension Dictionary where Key == OverviewItemType, Value == OverviewItem {
    
    static func placeholder(configs: [OverviewItemConfig]) -> Self {
        let data = RCOverviewResponse.stub
        return configs.reduce([OverviewItemType: OverviewItem]()) { partialResult, config in
            var partialResult = partialResult
            switch config.type {
            case .mrr:
                partialResult[config.type] = .init(value: .mrr(data.mrr ?? 0), config: config)
            case .subsciptions:
                partialResult[config.type] = .init(value: .subsciptions(data.activeSubscribersCount ?? 0), config: config)
            case .trials:
                partialResult[config.type] = .init(value: .trials(data.activeTrialsCount ?? 0), config: config)
            case .revenue:
                partialResult[config.type] = .init(value: .revenue(data.revenue ?? 0), config: config)
            case .users:
                partialResult[config.type] = .init(value: .users(data.activeUsersCount ?? 0), config: config)
            case .installs:
                partialResult[config.type] = .init(value: .installs(data.installsCount ?? 0), config: config)
            case .arr:
                partialResult[config.type] = .init(value: .arr(5234.342), config: config)
            case .proceeds:
                partialResult[config.type] = .init(value: .proceeds(89455.656), config: config)
            case .newUsers:
                partialResult[config.type] = .init(value: .newUsers(23433), config: config)
            case .churnRate:
                partialResult[config.type] = .init(value: .churnRate(23), config: config)
            case .subsciptionsLost:
                partialResult[config.type] = .init(value: .subsciptionsLost(433), config: config)
            }
            return partialResult
        }
    }
}

enum OverviewItemValue: Hashable, Equatable {
    
    case mrr(Double)
    case subsciptions(Int)
    case trials(Int)
    case revenue(Double)
    case users(Int)
    case installs(Int)
    case arr(Double)
    case proceeds(Double)
    case newUsers(Int)
    case churnRate(Double)
    case subsciptionsLost(Int)
    
    var type: OverviewItemType {
        switch self {
        case .mrr: .mrr
        case .subsciptions: .subsciptions
        case .trials: .trials
        case .revenue: .revenue
        case .users: .users
        case .installs: .installs
        case .arr: .arr
        case .proceeds: .proceeds
        case .newUsers: .newUsers
        case .churnRate: .churnRate
        case .subsciptionsLost: .subsciptionsLost
        }
    }
    
    var string: String {
        switch self {
        case .mrr(let double),
                .revenue(let double),
                .arr(let double),
                .proceeds(let double):
            return double.formatted(.currency(code: "USD"))
        case .subsciptions(let int),
                .trials(let int),
                .users(let int),
                .installs(let int),
                .newUsers(let int),
                .subsciptionsLost(let int):
            return int.formatted()
        case .churnRate(let double):
            return (double / 100).formatted(.percent)
        }
    }
}

struct OverviewItemConfig: Codable, Hashable {
    
    var type: OverviewItemType
    var timePeriod: OverviewItemTimePeriod
}

extension Array where Element == OverviewItemConfig {
    
    static var current: Self? {
        guard let data = UserDefaults.shared.overviewConfigs else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: data)
    }
    
    static let defaults: Self = {
        return [
            .init(type: .mrr, timePeriod: .allTime),
            .init(type: .subsciptions, timePeriod: .allTime),
            .init(type: .trials, timePeriod: .allTime),
            .init(type: .revenue, timePeriod: .last28Days),
            .init(type: .users, timePeriod: .last28Days),
            .init(type: .installs, timePeriod: .last28Days),
            .init(type: .arr, timePeriod: .allTime),
            .init(type: .proceeds, timePeriod: .allTime),
            .init(type: .newUsers, timePeriod: .allTime),
            .init(type: .churnRate, timePeriod: .allTime),
            .init(type: .subsciptionsLost, timePeriod: .allTime)
        ]
    }()
    
    static func get() -> Self {
        current ?? defaults
    }
    
    static func set(to configs: Self?) {
        UserDefaults.shared.overviewConfigs = try? JSONEncoder().encode(configs)
    }
}

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
        case .thisYear: "This year (Year to date)"
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
}

extension UserDefaults {
    
    static var shared: UserDefaults {
        .init(suiteName: "group.com.sereisoglu.kedi") ?? .standard
    }
}

extension UserDefaults {
    
    var overviewConfigs: Data? {
        get {
            data(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var appIcon: String? {
        get {
            string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
