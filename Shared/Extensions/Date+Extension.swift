//
//  Date+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import Foundation

extension Date {
    
    var calendar: Calendar {
        Calendar.current
    }
}

extension Date {
    
    var withoutTime: Date {
        let comps = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: comps) ?? self
    }
}

extension Date {
    
    func format(dateFormatter: DateFormatter) -> String {
        dateFormatter.string(from: self)
    }
    
    func relativeFormat(to relativeDateFormatter: RelativeDateTimeFormatter) -> String {
        relativeDateFormatter.localizedString(for: self, relativeTo: Date.now)
    }
}

extension Date {
    
    var isToday: Bool {
        calendar.isDateInToday(self)
    }
    
    var isFuture: Bool {
        self > Date.now
    }
}

extension Date {
    func nearestQuarterHourToTheFuture() -> Date {
        let granularity = 900.0 // 60.0 * 15.0
        
        return Date(timeIntervalSinceReferenceDate: (self.timeIntervalSinceReferenceDate / granularity).rounded(.up) * granularity)
    }
}


extension Date {
    
    var startOfWeek: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }
}

extension Date {
    
    var getHourTo18: Date {
        var comps = calendar.dateComponents([.year, .month, .day], from: self)
        comps.timeZone = .current
        comps.hour = 18
        return calendar.date(from: comps) ?? self
    }
    
    var getHourTo0: Date {
        var comps = calendar.dateComponents([.year, .month, .day], from: self)
        comps.timeZone = .current
        comps.hour = 0
        return calendar.date(from: comps) ?? self
    }
    
    var calcHourTo18: Date {
        if self >= getHourTo18 {
            return .init(getHourTo18: 1)
        } else {
            return getHourTo18
        }
    }
    
    init(getHourTo18 addingDay: Int) {
        self.init()
        let date = calendar.date(byAdding: .day, value: addingDay, to: Date()) ?? Date()
        self = date.getHourTo18
    }
    
    init(byAdding component: Calendar.Component, value: Int, to date: Date = Date()) {
        self.init()
        self = calendar.date(byAdding: component, value: value, to: date) ?? date
    }
    
    static func generate(from: Date, to: Date = Date(), isFromIncluded: Bool = true, isToIncluded: Bool = true) -> [Date] {
        let from = from.getHourTo0
        let to = to.getHourTo0
        
        guard from <= to else {
            return []
        }
        
        var dates = [Date]()
        
        var current = from
        while current <= to {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current) ?? current
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

extension Date {
    
    var year: Int {
        calendar.component(.year, from: self)
    }
    
    var month: Int {
        calendar.component(.month, from: self)
    }
    
    var weekOfYear: Int {
        calendar.component(.weekOfYear, from: self)
    }
    
    var hour: Int {
        calendar.component(.hour, from: self)
    }
    
    // https://stackoverflow.com/a/65498893/9212388
    var weekday: Int {
        (calendar.component(.weekday, from: self) - calendar.firstWeekday + 7) % 7 + 1
    }
}
