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
