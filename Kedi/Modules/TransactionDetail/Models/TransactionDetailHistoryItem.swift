//
//  TransactionDetailHistoryItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import SwiftUI

struct TransactionDetailHistoryItem: Identifiable, Hashable {
    
    let id = UUID()
    var type: TransactionDetailHistoryType
    var date: String
    
    init(data: RCSubscriberHistoryModel) {
        let price = (data.priceInPurchasedCurrency ?? 0) != 0 ? (data.priceInPurchasedCurrency ?? 0) : (data.priceInUsd ?? 0)
        let currency = (data.priceInPurchasedCurrency ?? 0) != 0 ? (data.currency ?? "USD") : "USD"
        
        switch data.event {
        case "installation":
            type = .installation
        case "subscriber_alias":
            type = .subscriberAlias(alias: data.alias ?? "n/a")
        case "last_seen":
            type = .lastSeen
        case "cancellation":
            type = .cancellation(
                price: price,
                currency: currency,
                productIdentifier: data.product ?? "n/a"
            )
        case "purchase":
            type = .initialPurchase(
                price: price,
                currency: currency,
                productIdentifier: data.product ?? "n/a"
            )
        case "renewal":
            type = .renewal(
                price: price,
                currency: currency,
                productIdentifier: data.product ?? "n/a"
            )
        case "trial_start":
            type = .trial(
                price: price,
                currency: currency,
                productIdentifier: data.product ?? "n/a"
            )
        case "trial_conversion":
            type = .conversion(
                price: price,
                currency: currency,
                productIdentifier: data.product ?? "n/a"
            )
        case "refund":
            type = .refund(
                price: price,
                currency: currency,
                productIdentifier: data.product ?? "n/a"
            )
        default:
            type = .unknown
        }
        
        if let date = DateFormatter.iso8601WithoutMilliseconds.date(from: data.at ?? "") {
            if date.isToday {
                self.date = date.relativeFormat(to: .full)
            } else  {
                self.date = date.formatted(date: .abbreviated, time: .shortened)
            }
        } else {
            self.date = "Unknown"
        }
    }
}

enum TransactionDetailHistoryType: Hashable {
    
    case installation
    case subscriberAlias(alias: String)
    case lastSeen
    case cancellation(price: Double, currency: String, productIdentifier: String)
    case initialPurchase(price: Double, currency: String, productIdentifier: String)
    case oneTimePurchase(price: Double, currency: String, productIdentifier: String)
    case renewal(price: Double, currency: String, productIdentifier: String)
    case trial(price: Double, currency: String, productIdentifier: String)
    case conversion(price: Double, currency: String, productIdentifier: String)
    case refund(price: Double, currency: String, productIdentifier: String)
    case unknown
    
    var text: String {
        switch self {
        case .installation: "Installation"
        case .subscriberAlias: "Subscriber Alias"
        case .lastSeen: "Last Seen"
        case .cancellation: "Cancellation"
        case .initialPurchase: "Initial Purchase"
        case .oneTimePurchase: "One-Time Purchase"
        case .renewal: "Renewal"
        case .trial: "Trial"
        case .conversion: "Conversion"
        case .refund: "Refund"
        case .unknown: "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .installation: .primary
        case .subscriberAlias: .primary
        case .lastSeen: .primary
        case .cancellation: .red
        case .initialPurchase: .blue
        case .oneTimePurchase: .purple
        case .renewal: .green
        case .trial: .orange
        case .conversion: .blue
        case .refund: .red
        case .unknown: .primary
        }
    }
}
