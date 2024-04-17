//
//  EventNotification.swift
//  OneSignalNotificationServiceExtension
//
//  Created by Saffet Emin Reisoğlu on 3/25/24.
//

import Foundation

struct EventNotification {
    
    let id: String
    let appId: String
    var type: EventNotificationType
    var date: Date?
    var timestamp: TimeInterval?
    var price: Double?
    var projectName: String?
    var productIdentifier: String?
    var store: String?
    var countryFlag: String?
    var country: String?
    var environment: String?
    var offerCode: String?
    
    var countryWithFlag: String? {
        if let countryFlag,
           let country {
            return "\(countryFlag) \(country)"
        } else {
            return nil
        }
    }
    
    var title: String {
        [
            "\(type.emoji) \(type.text)",
            price?.formatted(.currency(code: "USD"))
        ].compactMap { $0 }.joined(separator: " • ")
    }
    
    var body: String {
        [
            countryWithFlag,
            projectName,
            productIdentifier,
            store,
            offerCode,
            environment
        ].compactMap { $0 }.joined(separator: " • ")
    }
    
    init(data: RCEvent) {
        id = data.id ?? ""
        appId = data.appId ?? ""
        
        switch data.type {
        case "INITIAL_PURCHASE":
            if data.periodType == "TRIAL" {
                type = .trial
            } else { // NORMAL
                type = .initialPurchase
            }
        case "NON_RENEWING_PURCHASE":
            type = .oneTimePurchase
        case "RENEWAL":
            if data.isTrialConversion ?? false {
                type = .conversion
            } else {
                type = .renewal
            }
        case "CANCELLATION":
            if data.cancelReason == "CUSTOMER_SUPPORT" {
                type = .refund
            } else { // UNSUBSCRIBE
                type = .unsubscription
            }
        case "UNCANCELLATION":
            type = .resubscription
        case "EXPIRATION":
            //            if data.expirationReason == "BILLING_ERROR" {
            //                type = .billingIssue
            //            } else { // UNSUBSCRIBE
            type = .expiration
            //            }
        case "PRODUCT_CHANGE":
            type = .productChange
        case "BILLING_ISSUE":
            type = .billingIssue
        case "TRANSFER":
            type = .transfer
        case "TEST":
            type = .test
        case "SUBSCRIPTION_PAUSED":
            type = .unknown
        case "SUBSCRIPTION_EXTENDED":
            type = .unknown
        case "INVOICE_ISSUANCE":
            type = .unknown
        case "TEMPORARY_ENTITLEMENT_GRANT":
            type = .unknown
        default:
            type = .unknown
        }
        
        if let timestamp = data.eventTimestampMs {
            date = Date(timeIntervalSince1970: Double(timestamp) / 1000)
            self.timestamp = date?.timeIntervalSince1970
        }
        
        price = data.price != 0 ? data.price : nil
        if let productId = data.productId,
           let newProductId = data.newProductId {
            productIdentifier = "\(productId) → \(newProductId)"
        } else {
            productIdentifier = data.productId
        }
        store = data.store?.replacingOccurrences(of: "_", with: " ").capitalized
        countryFlag = data.countryCode?.countryFlag
        country = data.countryCode?.countryName
        environment = data.environment == "PRODUCTION" ? nil : data.environment?.capitalized
        offerCode = data.offerCode
    }
}

enum EventNotificationType {
    
    case initialPurchase
    case oneTimePurchase
    case renewal
    case trial
    case conversion
    case resubscription
    case unsubscription
    case expiration
    case billingIssue
    case refund
    case transfer
    case productChange
    case test
    case unknown
    
    var emoji: String {
        switch self {
        case .initialPurchase: "🔵"
        case .oneTimePurchase: "🟣"
        case .renewal: "🟢"
        case .trial: "🟠"
        case .conversion: "🔵"
        case .resubscription: "🟢"
        case .unsubscription: "🟡"
        case .expiration: "🔴"
        case .billingIssue: "🔴"
        case .refund: "🔴"
        case .transfer: "⚪"
        case .productChange: "⚪"
        case .test: "⚪"
        case .unknown: "⚪"
        }
    }
    
    var text: String {
        switch self {
        case .initialPurchase: "Initial Purchase"
        case .oneTimePurchase: "One-Time Purchase"
        case .renewal: "Renewal"
        case .trial: "Trial"
        case .conversion: "Conversion"
        case .resubscription: "Resubscription"
        case .unsubscription: "Unsubscription"
        case .expiration: "Expiration"
        case .billingIssue: "Billing Issue"
        case .refund: "Refund"
        case .transfer: "Transfer"
        case .productChange: "Product Change"
        case .test: "Test"
        case .unknown: "Unknown"
        }
    }
}
