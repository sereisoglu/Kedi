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
    
    init(byAdding component: Calendar.Component, value: Int, to date: Date = Date()) {
        self.init()
        self = calendar.date(byAdding: component, value: value, to: date) ?? date
    }
    
    mutating func byAdding(_ component: Calendar.Component, value: Int) {
        self = calendar.date(byAdding: component, value: value, to: self) ?? self
    }
}

extension Date {
    
    func format(to dateFormatter: DateFormatter) -> String {
        dateFormatter.string(from: self)
    }
}

extension Date {
    
    var isToday: Bool {
        calendar.isDateInToday(self)
    }
    
    var isFuture: Bool {
        self > Date.now
    }
    
    var startOfWeek: Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }
    
    var withoutTime: Date {
        let comps = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: comps) ?? self
    }
    
    // https://stackoverflow.com/a/65498893/9212388
    var weekday: Int {
        (calendar.component(.weekday, from: self) - calendar.firstWeekday + 7) % 7 + 1
    }
}

extension Date {
    
    var getHourTo0: Date {
        var comps = calendar.dateComponents([.year, .month, .day], from: self)
        comps.timeZone = .current
        comps.hour = 0
        return calendar.date(from: comps) ?? self
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
