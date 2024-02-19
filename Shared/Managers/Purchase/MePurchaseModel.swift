//
//  MePurchaseModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/18/24.
//

import Foundation

struct MeSubscriptionModel {
    
    var productType: PurchaseProductType
    var purchaseDate: Date
    var expirationDate: Date
    var willRenew: Bool
}

struct MeNonSubscriptionModel {
    
    var productType: PurchaseProductType
    var purchaseDate: Date
    var price: Decimal
}

enum MeSubscriptionType {
    
    case normal
    case supporterMonthly
    case fullSupporterMonthly
    case superSupporterMonthly
    
    init(productType: PurchaseProductType?) {
        switch productType {
        case .supporterMonthly:
            self = .supporterMonthly
        case .fullSupporterMonthly:
            self = .fullSupporterMonthly
        case .superSupporterMonthly:
            self = .superSupporterMonthly
        case .none:
            fallthrough
        default:
            self = .normal
        }
    }
}
