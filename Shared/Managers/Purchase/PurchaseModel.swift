//
//  PurchaseModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/18/24.
//

import Foundation
import RevenueCat

struct PurchaseModel: Identifiable, Hashable {
    
    let id = UUID()
    var package: Package
    var productType: PurchaseProductType
    
    var localizedPriceString: String {
        package.storeProduct.localizedPriceString
    }
    
    var price: Decimal {
        package.storeProduct.price
    }
    
    init?(package: Package) {
        guard let productType = PurchaseProductType(rawValue: package.storeProduct.productIdentifier) else {
            return nil
        }
        self.package = package
        self.productType = productType
    }
}

enum PurchaseProductType: String {
    
    case supporterMonthly = "kedi.supporter.monthly"
    case fullSupporterMonthly = "kedi.fullSupporter.monthly"
    case superSupporterMonthly = "kedi.superSupporter.monthly"
    
    case smallTip = "kedi.smallTip"
    case niceTip = "kedi.niceTip"
    case generousTip = "kedi.generousTip"
    case hugeTip = "kedi.hugeTip"
    
    var emoji: String {
        switch self {
        case .supporterMonthly: ""
        case .fullSupporterMonthly: ""
        case .superSupporterMonthly: ""
        case .smallTip: "🍪"
        case .niceTip: "☕️"
        case .generousTip: "🍔"
        case .hugeTip: "🚀"
        }
    }
    
    var name: String {
        switch self {
        case .supporterMonthly: "Supporter Monthly"
        case .fullSupporterMonthly: "Full Supporter Monthly"
        case .superSupporterMonthly: "Super Supporter Monthly"
        case .smallTip: "Small Tip"
        case .niceTip: "Nice Tip"
        case .generousTip: "Generous Tip"
        case .hugeTip: "Huge Tip"
        }
    }
    
    var distinctName: String {
        switch self {
        case .supporterMonthly: "Supporter"
        case .fullSupporterMonthly: "Full Supporter"
        case .superSupporterMonthly: "Super Supporter"
        case .smallTip: "Small"
        case .niceTip: "Nice"
        case .generousTip: "Generous"
        case .hugeTip: "Huge"
        }
    }
    
    var level: Int? {
        switch self {
        case .supporterMonthly: 1
        case .fullSupporterMonthly: 2
        case .superSupporterMonthly: 3
        default: nil
        }
    }
    
    var entitlement: PurchaseEntitlement {
        switch self {
        case .supporterMonthly,
                .fullSupporterMonthly,
                .superSupporterMonthly:
            return .supporter
        case .smallTip,
                .niceTip,
                .generousTip,
                .hugeTip:
            return .tip
        }
    }
    
    var next: Self? {
        switch self {
        case .supporterMonthly: .fullSupporterMonthly
        case .fullSupporterMonthly: .superSupporterMonthly
        case .superSupporterMonthly: nil
        case .smallTip: nil
        case .niceTip: nil
        case .generousTip: nil
        case .hugeTip: nil
        }
    }
}

enum PurchaseEntitlement: String {
    
    case supporter
    case tip
    
    var name: String {
        rawValue.uppercased()
    }
}
