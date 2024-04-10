//
//  RelativeDateTimeFormatter+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/29/24.
//

import Foundation

extension RelativeDateTimeFormatter {
    
    static let full: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.unitsStyle = .full
        return formatter
    }()
}
