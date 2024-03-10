//
//  WidgetError.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/12/24.
//

import Foundation

enum WidgetError: Error {
    
    case unauthorized
    case service(RCError)
}

extension WidgetError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Unauthorized"
        case .service(let error):
            return error.localizedDescription
        }
    }
}

extension WidgetError {
    
    var icon: String {
        switch self {
        case .unauthorized:
            return "hand.raised"
        case .service:
            return "exclamationmark.triangle"
        }
    }

    var title: String {
        switch self {
        case .unauthorized:
            return "Unauthorized!"
        case .service:
            return "Service Error!"
        }
    }

    var message: String {
        switch self {
        case .unauthorized:
            return "Sign in to access all features"
        case .service(let error):
            return error.localizedDescription
        }
    }
}
