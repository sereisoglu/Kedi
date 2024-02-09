//
//  RCTransactionsResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import Foundation

struct RCTransactionsResponse: Decodable {
    
    var firstPurchaseMs: Int?
    var lastPurchaseMs: Int?
    var transactions: [RCTransaction]?
    
    enum CodingKeys: String, CodingKey {
        case firstPurchaseMs = "first_purchase_ms"
        case lastPurchaseMs = "last_purchase_ms"
        case transactions
    }
}

struct RCTransaction: Decodable {
    
    var app: RCTransactionApp?
    var expiresDate: String?
    var isInIntroductoryPricePeriod: Bool?
    var isRenewal: Bool?
    var isSandbox: Bool?
    var isTrialConversion: Bool?
    var isTrialPeriod: Bool?
    var productIdentifier: String?
    var purchaseDate: String?
    var revenue: Double?
    var store: String?
    var storeTransactionIdentifier: String?
    var subscriberCountryCode: String?
    var subscriberId: String?
    var subscriberLastSeenPlatform: String?
    var wasRefunded: Bool?
    
    enum CodingKeys: String, CodingKey {
        case app
        case expiresDate = "expires_date"
        case isInIntroductoryPricePeriod = "is_in_introductory_price_period"
        case isRenewal = "is_renewal"
        case isSandbox = "is_sandbox"
        case isTrialConversion = "is_trial_conversion"
        case isTrialPeriod = "is_trial_period"
        case productIdentifier = "product_identifier"
        case purchaseDate = "purchase_date"
        case revenue
        case store
        case storeTransactionIdentifier = "store_transaction_identifier"
        case subscriberCountryCode = "subscriber_country_code"
        case subscriberId = "subscriber_id"
        case subscriberLastSeenPlatform = "subscriber_last_seen_platform"
        case wasRefunded = "was_refunded"
    }
}

struct RCTransactionApp: Decodable {
    
    var bundleId: String?
    var id: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case id
        case name
    }
}
