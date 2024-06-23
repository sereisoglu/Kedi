//
//  PurchaseError.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/23/24.
//

import Foundation

enum PurchaseError: Error, LocalizedError {
    
    case isPurchasing
    case packageNotFound
    case purchaseNotFound
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .isPurchasing: "A purchasing is already being done right now."
        case .packageNotFound: "No packages found."
        case .purchaseNotFound: "No purchases found."
        case .unknown(let error): error.localizedDescription
        }
    }
}
