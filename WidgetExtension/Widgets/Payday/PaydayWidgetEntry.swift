//
//  PaydayWidgetEntry.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/25/24.
//

import Foundation
import WidgetKit

struct PaydayWidgetEntry: TimelineEntry {
    
    var date: Date
    var state: AppStorePaydayState
    var paymentDate: Date?
    
    var paymentDateFormatted: String? {
        guard let paymentDate else {
            return nil
        }
        return paymentDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var paymentDateRelativeFormatted: String? {
        guard let paymentDate else {
            return nil
        }
        let remainingDays = paymentDate.days(since: .now) ?? 0
        if remainingDays > 0 {
            return "\(remainingDays + 1) days"
        } else {
            return paymentDate.formatted(.relative(presentation: .named)).capitalizedSentence
        }
    }
}

extension PaydayWidgetEntry {
    
    static var placeholder: Self {
        .init(
            date: .now,
            state: AppStorePayday.upcomingPayday?.state ?? .past,
            paymentDate: AppStorePayday.upcomingPayday?.paymentDate
        )
    }
}
