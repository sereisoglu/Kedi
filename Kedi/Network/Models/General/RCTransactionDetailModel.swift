//
//  RCTransactionDetailModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import Foundation

struct RCTransactionDetailModel: Decodable {
    
    var app: RCTransactionAppModel?
    var createdAt: String?
    var dollarsSpent: Double?
    var history: [RCSubscriberHistoryModel]?
    var lastSeen: String?
    var lastSeenAppVersion: String?
    var lastSeenCountry: String?
    var lastSeenLocale: String?
    var lastSeenPlatform: String?
    var lastSeenPlatformVersion: String?
    var lastSeenSDKVersion: String?
    var subscriberAttributes: [RCSubscriberAttributeModel]?
    var subscriptionStatuses: [RCSubscriptionStatusModel]?
    
    enum CodingKeys: String, CodingKey {
        case subscriber
    }
    
    enum SubscriberCodingKeys: String, CodingKey {
        case app
        case createdAt = "created_at"
        case dollarsSpent = "dollars_spent"
        case history
        case lastSeen = "last_seen"
        case lastSeenAppVersion = "last_seen_app_version"
        case lastSeenCountry = "last_seen_country"
        case lastSeenLocale = "last_seen_locale"
        case lastSeenPlatform = "last_seen_platform"
        case lastSeenPlatformVersion = "last_seen_platform_version"
        case lastSeenSDKVersion = "last_seen_sdk_version"
        case subscriberAttributes = "subscriber_attributes"
        case subscriptionStatus = "subscription_status"
    }
    
    enum SubscriptionStatusCodingKeys: String, CodingKey {
        case live
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let subscriberContainer = try container.nestedContainer(keyedBy: SubscriberCodingKeys.self, forKey: .subscriber)
        
        app = try subscriberContainer.decodeIfPresent(RCTransactionAppModel.self, forKey: .app)
        createdAt = try subscriberContainer.decodeIfPresent(String.self, forKey: .createdAt)
        dollarsSpent = try subscriberContainer.decodeIfPresent(Double.self, forKey: .dollarsSpent)
        history = try subscriberContainer.decodeIfPresent([RCSubscriberHistoryModel].self, forKey: .history)
        lastSeen = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeen)
        lastSeenAppVersion = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenAppVersion)
        lastSeenCountry = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenCountry)
        lastSeenLocale = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenLocale)
        lastSeenPlatform = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenPlatform)
        lastSeenPlatformVersion = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenPlatformVersion)
        lastSeenSDKVersion = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenSDKVersion)
        subscriberAttributes = try subscriberContainer.decodeIfPresent([RCSubscriberAttributeModel].self, forKey: .subscriberAttributes)
        
        let subscriptionStatusContainer = try subscriberContainer.nestedContainer(keyedBy: SubscriptionStatusCodingKeys.self, forKey: .subscriptionStatus)
        subscriptionStatuses = try subscriptionStatusContainer.decodeIfPresent([RCSubscriptionStatusModel].self, forKey: .live)
    }
}

struct RCSubscriberHistoryModel: Decodable {
    
    var at: String?
    var event: String?
    var alias: String?
    var currency: String?
    var priceInPurchasedCurrency: Double?
    var priceInUsd: Double?
    var product: String?
    
    enum CodingKeys: String, CodingKey {
        case at
        case event
        case alias
        case currency
        case priceInPurchasedCurrency = "price_in_purchased_currency"
        case priceInUsd = "price_in_usd"
        case product
    }
}

struct RCSubscriberAttributeModel: Decodable {
    
    var key: String?
    var value: String?
    
    enum CodingKeys: CodingKey {
        case key
        case value
    }
    
    enum ValueCodingKeys: CodingKey {
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        key = try container.decodeIfPresent(String.self, forKey: .key)
        let valueContainer = try container.nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)
        value = try valueContainer.decodeIfPresent(String.self, forKey: .value)
    }
}

struct RCSubscriptionStatusModel: Decodable {
    
    var billingIssuesDetectedAt: String?
    var cancellationDate: String?
    var entitlementIdentifier: String?
    var expiresDate: String?
    var isAutoRenewing: Bool?
    var isTrial: Bool?
    var productIdentifier: String?
    var purchaseDate: String?
    var refundedAt: String?
    var unsubscribeDetectedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case billingIssuesDetectedAt = "billing_issues_detected_at"
        case cancellationDate = "cancellation_date"
        case entitlements
        case expiresDate = "expires_date"
        case isAutoRenewing = "is_auto_renewing"
        case isTrial = "is_trial"
        case productIdentifier = "product_identifier"
        case purchaseDate = "purchase_date"
        case refundedAt = "refunded_at"
        case unsubscribeDetectedAt = "unsubscribe_detected_at"
    }
    
    init(
        billingIssuesDetectedAt: String? = nil,
        cancellationDate: String? = nil,
        entitlementIdentifier: String? = nil,
        expiresDate: String? = nil,
        isAutoRenewing: Bool? = nil,
        isTrial: Bool? = nil,
        productIdentifier: String? = nil,
        purchaseDate: String? = nil,
        refundedAt: String? = nil,
        unsubscribeDetectedAt: String? = nil
    ) {
        self.billingIssuesDetectedAt = billingIssuesDetectedAt
        self.cancellationDate = cancellationDate
        self.entitlementIdentifier = entitlementIdentifier
        self.expiresDate = expiresDate
        self.isAutoRenewing = isAutoRenewing
        self.isTrial = isTrial
        self.productIdentifier = productIdentifier
        self.purchaseDate = purchaseDate
        self.refundedAt = refundedAt
        self.unsubscribeDetectedAt = unsubscribeDetectedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        billingIssuesDetectedAt = try container.decodeIfPresent(String.self, forKey: .billingIssuesDetectedAt)
        cancellationDate = try container.decodeIfPresent(String.self, forKey: .cancellationDate)
        
        let entitlements = try container.decodeIfPresent([RCSubscriptionStatusEntitlementModel].self, forKey: .entitlements)
        entitlementIdentifier = entitlements?.first?.identifier
        
        expiresDate = try container.decodeIfPresent(String.self, forKey: .expiresDate)
        isAutoRenewing = try container.decodeIfPresent(Bool.self, forKey: .isAutoRenewing)
        isTrial = try container.decodeIfPresent(Bool.self, forKey: .isTrial)
        productIdentifier = try container.decodeIfPresent(String.self, forKey: .productIdentifier)
        purchaseDate = try container.decodeIfPresent(String.self, forKey: .purchaseDate)
        refundedAt = try container.decodeIfPresent(String.self, forKey: .refundedAt)
        unsubscribeDetectedAt = try container.decodeIfPresent(String.self, forKey: .unsubscribeDetectedAt)
    }
}

struct RCSubscriptionStatusEntitlementModel: Decodable {
    
    var identifier: String?
}
