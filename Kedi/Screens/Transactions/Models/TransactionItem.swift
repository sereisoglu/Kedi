//
//  TransactionItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import SwiftUI

struct TransactionSection: Identifiable, Hashable {
    
    var id: String { date.format(to: .iso8601WithoutMilliseconds) }
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
    
    let id: String
    let projectId: String
    let subscriberId: String
    
    var type: TransactionType
    var price: Double
    var store: TransactionStore?
    var projectIcon: Data?
    var projectName: String
    var productIdentifier: String
    var countryFlag: String
    var country: String
    var date: String
    
    init(data: RCTransaction, projectIcon: Data?) {
        id = data.storeTransactionIdentifier ?? UUID().uuidString
        projectId = data.app?.id ?? ""
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
        store = .init(store: data.store ?? "")
        self.projectIcon = projectIcon
        projectName = data.app?.name ?? ""
        productIdentifier = data.productIdentifier ?? ""
        countryFlag = data.subscriberCountryCode?.countryFlag ?? ""
        country = data.subscriberCountryCode?.countryName ?? ""
        if let date = data.purchaseDate?.format(to: .iso8601WithoutMilliseconds) {
            if date.isToday || date.isFuture {
                self.date = date.formatted(.relative(presentation: .named))
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
        case .initialPurchase: "New Subscription"
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
    
    var image: ImageResource {
        switch self {
        case .appStore: .appStore
        case .playStore: .playStore
        case .stripe: .stripe
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

extension Array where Element == TransactionSection {
    
    static let stub: Self = {
        let groupedTransactions = Dictionary(grouping: RCTransactionsResponse.stub.transactions ?? []) { transaction in
            transaction.purchaseDate?.format(to: .iso8601WithoutMilliseconds)?.withoutTime
        }
        
        return groupedTransactions
            .compactMap { date, transactions in
                guard let date else {
                    return nil
                }
                return .init(
                    date: date,
                    transactions: transactions.compactMap { transaction in
                        guard let projectId = transaction.app?.id else {
                            return nil
                        }
                        return .init(
                            data: transaction,
                            projectIcon: nil
                        )
                    }
                )
            }
            .sorted(by: { $0.date > $1.date })
    }()
}
