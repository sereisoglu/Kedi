//
//  Date+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import Foundation

extension Date {
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    var isToday: Bool {
        calendar.isDateInToday(self)
    }
    
    var isFuture: Bool {
        self > .now
    }
    
    var withoutTime: Date {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: dateComponents) ?? self
    }
    
    var startOfDay: Date {
        calendar.startOfDay(for: self)
    }
    
    var startOfWeek: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }
    
    // https://stackoverflow.com/a/65498893/9212388
    var weekday: Int {
        (calendar.component(.weekday, from: self) - calendar.firstWeekday + 7) % 7 + 1
    }
    
    func byAdding(_ component: Calendar.Component, value: Int) -> Date {
        calendar.date(byAdding: component, value: value, to: self) ?? self
    }
}

extension Date {
    
    func format(to dateFormatter: DateFormatter) -> String {
        dateFormatter.string(from: self)
    }
}

extension Date {
    
    // https://stackoverflow.com/a/72765548/9212388
    func nearestDate(secondGranularity: Double) -> Date {
        .init(timeIntervalSinceReferenceDate: (self.timeIntervalSinceReferenceDate / secondGranularity).rounded(.up) * secondGranularity)
    }
}

extension Date {
    
    // https://stackoverflow.com/a/45757921/9212388
    func days(since: Date) -> Int? {
        Calendar.current.dateComponents([.day], from: since, to: self).day
    }
}

extension Date {
    
    static func generate(
        from: Date,
        to: Date = Date(),
        isFromIncluded: Bool = true,
        isToIncluded: Bool = true
    ) -> [Date] {
        let calendar = Calendar.current
        let from = calendar.startOfDay(for: from)
        let to = calendar.startOfDay(for: to)
        
        guard from <= to else {
            return []
        }
        
        var dates = [Date]()
        
        var current = from
        while current <= to {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }
        
        if !isFromIncluded {
            dates = Array(dates.dropFirst())
        }
        
        if !isToIncluded {
            dates = dates.dropLast()
        }
        
        return dates
    }
}
