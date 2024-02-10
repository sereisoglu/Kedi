//
//  TransactionDetailEntitlementItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import Foundation

struct TransactionDetailEntitlementItem: Identifiable, Hashable {
    
    let id = UUID()
    var type: TransactionDetailEntitlementType
    var entitlementIdentifier: String
    var productIdentifier: String
    var description: String
    
    init(data: RCSubscriptionStatus) {
        if let date = data.refundedAt?.format(to: .iso8601WithoutMilliseconds) {
            type = .refunded
            description = "Refunded on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let date = data.billingIssuesDetectedAt?.format(to: .iso8601WithoutMilliseconds) {
            type = .billingIssue
            description = "Billing issue detected on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let date = data.expiresDate?.format(to: .iso8601WithoutMilliseconds),
                  !date.isFuture {
            type = .expired
            description = "Subscription expired on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let date = data.unsubscribeDetectedAt?.format(to: .iso8601WithoutMilliseconds) {
            type = .unsubscribed
            description = "Unsubscribed on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let date = data.cancellationDate?.format(to: .iso8601WithoutMilliseconds) {
            type = .cancelled
            description = "Cancelled on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let date = data.expiresDate?.format(to: .iso8601WithoutMilliseconds) {
            if data.isTrial ?? false {
                type = .trial
            } else {
                type = .subscription
            }
            description = "Subscription expires on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else {
            type = .oneTimePurchase
            if let date = data.purchaseDate?.format(to: .iso8601WithoutMilliseconds) {
                description = "Purchased on \(date.formatted(date: .abbreviated, time: .shortened))"
            } else {
                description = "n/a"
            }
        }
        
        entitlementIdentifier = data.entitlementIdentifier ?? "n/a"
        productIdentifier = data.productIdentifier ?? "n/a"
    }
}

enum TransactionDetailEntitlementType {
    
    case subscription
    case oneTimePurchase
    case expired
    case trial
    case unsubscribed
    case cancelled
    case billingIssue
    case refunded
    
    var status: String {
        switch self {
        case .subscription: "🟢"
        case .oneTimePurchase: "🟢"
        case .expired: "❌"
        case .trial: "🟠"
        case .unsubscribed: "🔴"
        case .cancelled: "🔴"
        case .billingIssue: "🔴"
        case .refunded: "❌"
        }
    }
}
