//
//  AppStorePayday.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/25/24.
//

import Foundation

struct AppStorePayday: Decodable, Identifiable, Hashable {
    
    var id = UUID()
    var fiscalYear: Int
    var fiscalMonth: Date
    var startDate: Date
    var endDate: Date
    var paymentDate: Date
    
    var state: AppStorePaydayState {
        if isPaymentDateToday {
            return .today
        } else if isPaymentDateTomorrow {
            return .tomorrow
        } else if paymentDate == Self.upcomingPayday?.paymentDate {
            return .upcoming
        } else {
            return paymentDate.isFuture ? .future : .past
        }
    }
    
    var isPaymentDateToday: Bool {
        let calendar = Calendar.current
        return calendar.component(.day, from: paymentDate) == calendar.component(.day, from: .now)
    }
    
    var isPaymentDateTomorrow: Bool {
        let calendar = Calendar.current
        return calendar.component(.day, from: paymentDate) == calendar.component(.day, from: calendar.date(byAdding: .day, value: 1, to: .now) ?? .now)
    }
    
    var emoji: String {
        state.emoji
    }
    
    var fiscalMonthFormatted: String {
        fiscalMonth.formatted(.dateTime.month().year())
    }
    
    var startDateFormatted: String {
        startDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var endDateFormatted: String {
        endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var paymentDateFormatted: String {
        paymentDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var paymentDateRelativeFormatted: String {
        paymentDate.formatted(.relative(presentation: .named)).localizedCapitalized
    }
    
    enum CodingKeys: String, CodingKey {
        case fiscalYear
        case fiscalMonth
        case startDate
        case endDate
        case paymentDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        fiscalYear = try container.decode(Int.self, forKey: .fiscalYear)
        let fiscalMonthString = try container.decode(String.self, forKey: .fiscalMonth)
        fiscalMonth = DateFormatter.yyy_MM.date(from: fiscalMonthString) ?? Date()
        let startDateString = try container.decode(String.self, forKey: .startDate)
        startDate = DateFormatter.yyy_MM_dd.date(from: startDateString) ?? Date()
        let endDateString = try container.decode(String.self, forKey: .endDate)
        endDate = DateFormatter.yyy_MM_dd.date(from: endDateString) ?? Date()
        let paymentDateString = try container.decode(String.self, forKey: .paymentDate)
        paymentDate = DateFormatter.yyy_MM_dd.date(from: paymentDateString) ?? Date()
    }
}

enum AppStorePaydayState {
    
    case today
    case tomorrow
    case upcoming
    case future
    case past
    
    var emoji: String {
        switch self {
        case .today: "🤑"
        case .tomorrow: "🔥"
        case .upcoming: "⏳"
        case .future: "☑️"
        case .past: "✅"
        }
    }
    
    var isUpcoming: Bool {
        [.today, .tomorrow, .upcoming].contains(self)
    }
}

extension AppStorePayday {
    
    static var upcomingPayday: Self? {
        Self.paydays.first { $0.paymentDate > .now || $0.isPaymentDateToday }
    }
}

extension AppStorePayday {
    // "paymentDate": "2024-03-07"
    static let paydays: [Self] = {
        let string = #"""
        [
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2023-10",
                "startDate": "2023-10-01",
                "endDate": "2023-11-04",
                "paymentDate": "2023-12-07"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2023-11",
                "startDate": "2023-11-05",
                "endDate": "2023-12-02",
                "paymentDate": "2024-01-04"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2023-12",
                "startDate": "2023-12-03",
                "endDate": "2023-12-30",
                "paymentDate": "2024-02-01"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-01",
                "startDate": "2023-12-31",
                "endDate": "2024-02-03",
                "paymentDate": "2024-02-27"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-02",
                "startDate": "2024-02-04",
                "endDate": "2024-03-02",
                "paymentDate": "2024-04-04"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-03",
                "startDate": "2024-03-03",
                "endDate": "2024-03-30",
                "paymentDate": "2024-05-02"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-04",
                "startDate": "2024-03-31",
                "endDate": "2024-05-04",
                "paymentDate": "2024-06-06"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-05",
                "startDate": "2024-05-05",
                "endDate": "2024-06-01",
                "paymentDate": "2024-07-04"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-06",
                "startDate": "2024-06-02",
                "endDate": "2024-06-29",
                "paymentDate": "2024-08-01"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-07",
                "startDate": "2024-06-30",
                "endDate": "2024-08-03",
                "paymentDate": "2024-09-05"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-08",
                "startDate": "2024-08-04",
                "endDate": "2024-08-31",
                "paymentDate": "2024-10-03"
            },
            {
                "fiscalYear": 2024,
                "fiscalMonth": "2024-09",
                "startDate": "2024-09-01",
                "endDate": "2024-09-28",
                "paymentDate": "2024-10-31"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2024-10",
                "startDate": "2024-09-29",
                "endDate": "2024-11-02",
                "paymentDate": "2024-12-05"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2024-11",
                "startDate": "2024-11-03",
                "endDate": "2024-11-30",
                "paymentDate": "2025-01-02"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2024-12",
                "startDate": "2024-12-01",
                "endDate": "2024-12-28",
                "paymentDate": "2025-01-30"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-01",
                "startDate": "2024-12-29",
                "endDate": "2025-02-01",
                "paymentDate": "2025-03-06"
            }
        ]
        """#
        
        // 2024-09: "2024-11-07" -> "2024-10-31"
        
        return try! JSONDecoder().decode([Self].self, from: .init(string.utf8))
    }()
}
