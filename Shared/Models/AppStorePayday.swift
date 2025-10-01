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
        paymentDate.isToday
    }
    
    var isPaymentDateTomorrow: Bool {
        paymentDate.isTomorrow
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
        let remainingDays = paymentDate.days(since: .now) ?? 0
        if remainingDays > 0 {
            return "\(remainingDays + 1) days"
        } else {
            return paymentDate.formatted(.relative(presentation: .named)).capitalizedSentence
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case fiscalYear
        case fiscalMonth
        case startDate
        case endDate
        case paymentDate
    }
    
    init(
        fiscalYear: Int,
        fiscalMonth: Date,
        startDate: Date,
        endDate: Date,
        paymentDate: Date
    ) {
        self.fiscalYear = fiscalYear
        self.fiscalMonth = fiscalMonth
        self.startDate = startDate
        self.endDate = endDate
        self.paymentDate = paymentDate
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
    
    var title: String {
        switch self {
        case .today: "Today"
        case .tomorrow: "Tomorrow"
        case .upcoming: "Upcoming"
        case .future: "Future"
        case .past: "Past"
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
    
    static var nextToUpcomingPayday: Self? {
        guard let upcomingPayday = Self.upcomingPayday,
              let index = Self.paydays.firstIndex(where: { upcomingPayday.paymentDate == $0.paymentDate }) else {
            return nil
        }
        return Self.paydays[safe: index + 1]
    }
}

extension AppStorePayday {
    
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
                "paymentDate": "2024-03-07"
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
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-02",
                "startDate": "2025-02-02",
                "endDate": "2025-03-01",
                "paymentDate": "2025-04-03"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-03",
                "startDate": "2025-03-02",
                "endDate": "2025-03-29",
                "paymentDate": "2025-05-01"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-04",
                "startDate": "2025-03-30",
                "endDate": "2025-05-03",
                "paymentDate": "2025-06-05"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-05",
                "startDate": "2025-05-04",
                "endDate": "2025-05-31",
                "paymentDate": "2025-07-03"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-06",
                "startDate": "2025-06-01",
                "endDate": "2025-06-28",
                "paymentDate": "2025-07-31"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-07",
                "startDate": "2025-06-29",
                "endDate": "2025-08-02",
                "paymentDate": "2025-09-04"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-08",
                "startDate": "2025-08-03",
                "endDate": "2025-08-30",
                "paymentDate": "2025-10-02"
            },
            {
                "fiscalYear": 2025,
                "fiscalMonth": "2025-09",
                "startDate": "2025-08-31",
                "endDate": "2025-09-27",
                "paymentDate": "2025-10-30"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2025-10",
                "startDate": "2025-09-28",
                "endDate": "2025-11-01",
                "paymentDate": "2025-12-04"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2025-11",
                "startDate": "2025-11-02",
                "endDate": "2025-11-29",
                "paymentDate": "2026-01-01"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2025-12",
                "startDate": "2025-11-30",
                "endDate": "2025-12-27",
                "paymentDate": "2026-01-29"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-01",
                "startDate": "2025-12-28",
                "endDate": "2026-01-31",
                "paymentDate": "2026-03-05"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-02",
                "startDate": "2026-02-01",
                "endDate": "2026-02-28",
                "paymentDate": "2026-04-02"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-03",
                "startDate": "2026-03-01",
                "endDate": "2026-03-28",
                "paymentDate": "2026-04-30"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-04",
                "startDate": "2026-03-29",
                "endDate": "2026-05-02",
                "paymentDate": "2026-06-04"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-05",
                "startDate": "2026-05-03",
                "endDate": "2026-05-30",
                "paymentDate": "2026-07-02"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-06",
                "startDate": "2026-05-31",
                "endDate": "2026-06-27",
                "paymentDate": "2026-07-30"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-07",
                "startDate": "2026-06-28",
                "endDate": "2026-08-01",
                "paymentDate": "2026-09-03"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-08",
                "startDate": "2026-08-02",
                "endDate": "2026-08-29",
                "paymentDate": "2026-10-01"
            },
            {
                "fiscalYear": 2026,
                "fiscalMonth": "2026-09",
                "startDate": "2026-08-30",
                "endDate": "2026-09-26",
                "paymentDate": "2026-10-29"
            }
        ]
        """#
        
        // 2024-09: "2024-11-07" -> "2024-10-31"
        
        return (try? JSONDecoder.default.decode([Self].self, from: .init(string.utf8))) ?? []
    }()
}
