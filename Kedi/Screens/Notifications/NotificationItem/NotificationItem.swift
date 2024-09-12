//
//  NotificationItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/14/24.
//

import SwiftUI

struct NotificationSection: Identifiable, Hashable {
    
    var id: String { date.format(to: .iso8601WithoutMilliseconds) }
    var date: Date
    var notifications: [NotificationItem]
}

struct NotificationItem: Identifiable, Hashable {
    
    var id: String
    var appId: String
    var subscriberId: String
    var date: Date?
    
    var type: NotificationType
    var price: Double?
    var store: NotificationStore?
    var projectIcon: Data?
    var projectName: String
    var productIdentifier: String?
    var countryFlag: String
    var country: String
    var formattedDate: String
    var subscriberAttributes: String?
    
    init(data: RCEvent, project: Project) {
        id = data.id ?? ""
        appId = data.appId ?? ""
        subscriberId = data.appUserId ?? ""
        if let timestamp = data.eventTimestampMs {
            date = Date(timeIntervalSince1970: Double(timestamp) / 1000)
        }
        
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
                let diffMs = (data.eventTimestampMs ?? 0) - (data.purchasedAtMs ?? 0)
                type = diffMs >= 0 ? .renewalLapsed : .renewalExisting
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
            if (data.transferredTo?.count ?? 0) > 1 {
                subscriberId = data.transferredTo?.first(where: { !$0.contains("RCAnonymousID") }) ?? ""
            } else {
                subscriberId = data.transferredTo?.first ?? ""
            }
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
        
        price = data.price != 0 ? data.price : nil
        store = .init(store: data.store ?? "")
        projectIcon = project.icon
        projectName = project.name
        if let productId = data.productId,
           let newProductId = data.newProductId {
            productIdentifier = "\(productId) → \(newProductId)"
        } else {
            productIdentifier = data.productId
        }
        countryFlag = data.countryCode?.countryFlag ?? ""
        country = data.countryCode?.countryName ?? ""
        if let date {
            if date.isToday || date.isFuture {
                formattedDate = date.formatted(.relative(presentation: .named))
            } else  {
                formattedDate = date.formatted(date: .omitted, time: .standard)
            }
        } else {
            formattedDate = "Unknown"
        }
        subscriberAttributes = [
            data.subscriberAttributes?["$email"]?.value,
            data.subscriberAttributes?["$displayName"]?.value,
            data.subscriberAttributes?["username"]?.value,
            data.environment == "PRODUCTION" ? nil : data.environment?.capitalized,
            data.offerCode
        ].compactMap { $0 }.joined(separator: " • ")
        if subscriberAttributes?.isEmpty ?? false {
            subscriberAttributes = nil
        }
    }
}

enum NotificationType {
    
    case initialPurchase
    case oneTimePurchase
    case renewalExisting
    case renewalLapsed
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
    
    var color: Color {
        switch self {
        case .initialPurchase: .blue
        case .oneTimePurchase: .purple
        case .renewalExisting: .green
        case .renewalLapsed: .blue
        case .trial: .orange
        case .conversion: .blue
        case .resubscription: .green
        case .unsubscription: .yellow
        case .expiration: .red
        case .billingIssue: .red
        case .refund: .red
        case .transfer: .primary
        case .productChange: .primary
        case .test: .primary
        case .unknown: .primary
        }
    }
    
    var text: String {
        switch self {
        case .initialPurchase: "Initial Purchase"
        case .oneTimePurchase: "One-Time Purchase"
        case .renewalExisting: "Renewal (Existing)"
        case .renewalLapsed: "Renewal (Lapsed)"
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

enum NotificationStore {
    
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
        case "APP_STORE":
            self = .appStore
        case "PLAY_STORE":
            self = .playStore
        case "STRIPE":
            self = .stripe
        default:
            return nil
        }
    }
}

extension Array where Element == NotificationSection {
    
    static let stub: Self = {
        let project = Project(id: "p0001", name: "Kedi")
        let notifications: [NotificationItem] = RCLatestEventsResponse.stub.events?.map { NotificationItem(data: $0, project: project) } ?? []
        
        let groupedNotifications = Dictionary(grouping: notifications) { notification in
            notification.date?.withoutTime
        }
        
        return groupedNotifications
            .compactMap { date, notifications in
                guard let date else {
                    return nil
                }
                return .init(date: date, notifications: notifications)
            }
            .sorted(by: { $0.date > $1.date })
    }()
}
