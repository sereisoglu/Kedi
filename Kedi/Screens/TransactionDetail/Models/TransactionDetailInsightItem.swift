//
//  TransactionDetailInsightItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/29/24.
//

import Foundation

struct TransactionDetailInsightItem: Identifiable, Hashable {
    
    let id = UUID()
    var type: TransactionDetailInsightType
    var text: String
}

enum TransactionDetailInsightType {
    
    case firstPurchase
    case spentDollarsSinceLastSeen
    case refundCount
    case transferCount
    
    var emoji: String {
        switch self {
        case .firstPurchase: "🤑"
        case .spentDollarsSinceLastSeen: "💸"
        case .refundCount: "❌"
        case .transferCount: "🔁"
        }
    }
}
