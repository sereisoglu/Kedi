//
//  Error+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/23/24.
//

import Foundation

extension Error {
    
    var displayableLocalizedDescription: String {
        localizedDescription.replacingOccurrences(of: "URLSessionTask failed with error: ", with: "")
    }
}
