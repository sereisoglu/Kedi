//
//  TransactionModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import SwiftUI

struct TransactionDailyModel: Identifiable, Hashable {
    
    let id = UUID()
    var date: Date
    var transactions: [TransactionModel]
    var revenue: Double
    
    init(date: Date, transactions: [TransactionModel]) {
        self.date = date
        self.transactions = transactions
        self.revenue = transactions.map(\.price).reduce(0, +)
    }
}

struct TransactionModel: Identifiable, Hashable {
    
    let id = UUID()
    var type: TransactionType
    var color: Color
    var price: Double
    var store: TransactionStore?
    var appIconUrl: String?
    var appName: String
    var productIdentifier: String
    var countryFlag: String
    var country: String
    var date: Date?
    
    var dateText: Text {
        if let date {
            if date.isToday {
                Text(date, format: .relative(presentation: .named))
            } else {
                Text(date.formatted(date: .omitted, time: .standard))
            }
        } else {
            Text("Unknown")
        }
    }
    
    init(data: RCTransactionModel) {
        if data.wasRefunded ?? false {
            type = .refund
            color = .red
        } else if data.isRenewal ?? false {
            type = .renewal
            color = .green
        } else if data.isTrialPeriod ?? false {
            type = .trial
            color = .orange
        } else if data.isTrialConversion ?? false {
            type = .conversion
            color = .blue
        } else {
            type = .purchase
            color = .blue
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
        
        countryFlag = data.subscriberCountryCode?.flag ?? ""
        
        country = Locale.current.localizedString(forRegionCode: data.subscriberCountryCode ?? "") ?? ""
        
        date = DateFormatter.iso8601WithoutMilliseconds.date(from: data.purchaseDate ?? "")
    }
}

enum TransactionType {
    
    case purchase
    case renewal
    case trial
    case conversion
    case refund
    
    var text: String {
        switch self {
        case .purchase: "Purchase"
        case .renewal: "Renewal"
        case .trial: "Trial"
        case .conversion: "Conversion"
        case .refund: "Refund"
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
