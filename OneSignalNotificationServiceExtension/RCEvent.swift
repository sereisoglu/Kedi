//
//  RCEvent.swift
//  OneSignalNotificationServiceExtension
//
//  Created by Saffet Emin Reisoğlu on 3/25/24.
//

import Foundation

struct RCEvent: Decodable {
    
    var aliases: [String]?
    var appId: String?
    var appUserId: String?
    var commissionPercentage: Double?
    var countryCode: String?
    var currency: String?
    var entitlementId: String?
    var entitlementIds: [String]?
    var environment: String?
    var eventTimestampMs: Int?
    var expirationAtMs: Int?
    var id: String?
    var isFamilyShare: Bool?
    var offerCode: String?
    var originalAppUserId: String?
    var originalTransactionId: String?
    var periodType: String?
    var presentedOfferingId: String?
    var price: Double?
    var priceInPurchasedCurrency: Double?
    var productId: String?
    var purchasedAtMs: Int?
    var store: String?
    var subscriberAttributes: [String: RCEventSubscriberAttribute]?
    var takehomePercentage: Double?
    var taxPercentage: Double?
    var transactionId: String?
    var type: String?
    var expirationReason: String?
    var isTrialConversion: Bool?
    var cancelReason: String?
    var transferredFrom: [String]?
    var transferredTo: [String]?
    
    enum CodingKeys: String, CodingKey {
        case aliases
        case appId = "app_id"
        case appUserId = "app_user_id"
        case commissionPercentage = "commission_percentage"
        case countryCode = "country_code"
        case currency
        case entitlementId = "entitlement_id"
        case entitlementIds = "entitlement_ids"
        case environment
        case eventTimestampMs = "event_timestamp_ms"
        case expirationAtMs = "expiration_at_ms"
        case id
        case isFamilyShare = "is_family_share"
        case offerCode = "offer_code"
        case originalAppUserId = "original_app_user_id"
        case originalTransactionId = "original_transaction_id"
        case periodType = "period_type"
        case presentedOfferingId = "presented_offering_id"
        case price
        case priceInPurchasedCurrency = "price_in_purchased_currency"
        case productId = "product_id"
        case purchasedAtMs = "purchased_at_ms"
        case store
        case subscriberAttributes = "subscriber_attributes"
        case takehomePercentage = "takehome_percentage"
        case taxPercentage = "tax_percentage"
        case transactionId = "transaction_id"
        case type
        case expirationReason = "expiration_reason"
        case isTrialConversion = "is_trial_conversion"
        case cancelReason = "cancel_reason"
        case transferredFrom = "transferred_from"
        case transferredTo = "transferred_to"
    }
}

struct RCEventSubscriberAttribute: Decodable {
    
    var updatedAtMs: Int?
    var value: String?
    
    enum CodingKeys: String, CodingKey {
        case updatedAtMs = "updated_at_ms"
        case value
    }
}
