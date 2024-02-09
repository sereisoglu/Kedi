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
        if let refundedAt = data.refundedAt,
           let date = DateFormatter.iso8601WithoutMilliseconds.date(from: refundedAt) {
            type = .refunded
            description = "Refunded on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let billingIssuesDetectedAt = data.billingIssuesDetectedAt,
                  let date = DateFormatter.iso8601WithoutMilliseconds.date(from: billingIssuesDetectedAt) {
            type = .billingIssue
            description = "Billing issue detected on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let expiresDate = data.expiresDate,
                  let date = DateFormatter.iso8601WithoutMilliseconds.date(from: expiresDate),
                  !date.isFuture {
            type = .expired
            description = "Subscription expired on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let unsubscribeDetectedAt = data.unsubscribeDetectedAt,
                  let date = DateFormatter.iso8601WithoutMilliseconds.date(from: unsubscribeDetectedAt) {
            type = .unsubscribed
            description = "Unsubscribed on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let cancellationDate = data.cancellationDate,
                  let date = DateFormatter.iso8601WithoutMilliseconds.date(from: cancellationDate) {
            type = .cancelled
            description = "Cancelled on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else if let expiresDate = data.expiresDate,
                  let date = DateFormatter.iso8601WithoutMilliseconds.date(from: expiresDate) {
            if data.isTrial ?? false {
                type = .trial
            } else {
                type = .subscription
            }
            description = "Subscription expires on \(date.formatted(date: .abbreviated, time: .shortened))"
        } else {
            type = .oneTimePurchase
            if let purchaseDate = data.purchaseDate,
               let date = DateFormatter.iso8601WithoutMilliseconds.date(from: purchaseDate) {
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
