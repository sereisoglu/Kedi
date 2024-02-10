//
//  TransactionItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import SwiftUI

struct TransactionSection: Identifiable, Hashable {
    
    let id = UUID()
    var date: Date
    var transactions: [TransactionItem]
    var revenue: Double
    
    init(date: Date, transactions: [TransactionItem]) {
        self.date = date
        self.transactions = transactions
        self.revenue = transactions.map(\.price).reduce(0, +)
    }
}

struct TransactionItem: Identifiable, Hashable {
    
    let id = UUID()
    let appId: String
    let subscriberId: String
    
    var type: TransactionType
    var price: Double
    var store: TransactionStore?
    var appIconUrl: String?
    var appName: String
    var productIdentifier: String
    var countryFlag: String
    var country: String
    var date: String
    
    init(data: RCTransaction) {
        appId = data.app?.id ?? ""
        subscriberId = data.subscriberId ?? ""
        
        if data.wasRefunded ?? false {
            type = .refund
        } else if data.isRenewal ?? false {
            type = .renewal
        } else if data.isTrialPeriod ?? false {
            type = .trial
        } else if data.isTrialConversion ?? false {
            type = .conversion
        } else if data.expiresDate != nil {
            type = .initialPurchase
        } else {
            type = .oneTimePurchase
        }
        
        price = data.revenue ?? 0
        
        if let store = data.store {
            self.store = .init(store: store)
        }
        
        if let bundleId = data.app?.bundleId {
            appIconUrl = "https://www.appatar.io/\(bundleId)/small"
        }
        
        appName = data.app?.name ?? ""
        
        productIdentifier = data.productIdentifier ?? ""
        
        countryFlag = data.subscriberCountryCode?.countryFlag ?? ""
        
        country = data.subscriberCountryCode?.countryName ?? ""
        
        if let date = data.purchaseDate?.format(to: .iso8601WithoutMilliseconds) {
            if date.isToday || date.isFuture {
                self.date = date.relativeFormat(to: .full)
            } else  {
                self.date = date.formatted(date: .omitted, time: .standard)
            }
        } else {
            self.date = "Unknown"
        }
    }
}

enum TransactionType {
    
    case initialPurchase
    case oneTimePurchase
    case renewal
    case trial
    case conversion
    case refund
    
    var text: String {
        switch self {
        case .initialPurchase: "Initial Purchase"
        case .oneTimePurchase: "One-Time Purchase"
        case .renewal: "Renewal"
        case .trial: "Trial"
        case .conversion: "Conversion"
        case .refund: "Refund"
        }
    }
    
    var color: Color {
        switch self {
        case .initialPurchase: .blue
        case .oneTimePurchase: .purple
        case .renewal: .green
        case .trial: .orange
        case .conversion: .blue
        case .refund: .red
        }
    }
}

enum TransactionStore {
    
    case appStore
    case playStore
    case stripe
    // amazonStore?
    
    var imageName: String {
        switch self {
        case .appStore: "app-store"
        case .playStore: "play-store"
        case .stripe: "stripe"
        }
    }
    
    init?(store: String) {
        switch store {
        case "App Store":
            self = .appStore
        case "Play Store":
            self = .playStore
        case "Stripe":
            self = .stripe
        default:
            return nil
        }
    }
}
