//
//  String+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import Foundation

extension String {
    
    // https://stackoverflow.com/a/60413173/9212388
    var countryFlag: String {
        self
            .unicodeScalars
            .map { 127397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    var countryName: String? {
        Locale.current.localizedString(forRegionCode: self)
    }
    
    var countryFlagAndName: String {
        "\(countryFlag) \(countryName ?? "Unknown")"
    }
}

extension String {
    
    func toDate(formatter: DateFormatter) -> Date? {
        formatter.date(from: self)
    }
    
    func format(to dateFormatter: DateFormatter) -> Date? {
        dateFormatter.date(from: self)
    }
    
    func relativeDate(from dateFormatter: DateFormatter) -> String? {
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        return date.formatted(.relative(presentation: .named))
    }
}

// https://sarunw.com/posts/how-to-capitalize-the-first-letter-in-swift
extension String {
    
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}
