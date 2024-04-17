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

extension RCTransactionsResponse {
    
    static let stub: Self = {
        let string = #"""
        {
            "first_purchase_ms": 1707299898000,
            "last_purchase_ms": 1704034951000,
            "transactions": [
                {
                    "app": {
                        "bundle_id": "com.sereisoglu.kedi",
                        "id": "a001",
                        "name": "Kedi"
                    },
                    "expires_date": "2024-03-07T09:00:00Z",
                    "is_in_introductory_price_period": false,
                    "is_renewal": false,
                    "is_sandbox": false,
                    "is_trial_conversion": false,
                    "is_trial_period": false,
                    "product_identifier": "kedi.supporter.monthly",
                    "purchase_date": "2024-02-07T09:00:00Z",
                    "revenue": 2.99,
                    "store": "App Store",
                    "store_transaction_identifier": "t001",
                    "subscriber_country_code": "US",
                    "subscriber_id": "s001",
                    "subscriber_last_seen_platform": "iOS",
                    "was_refunded": false
                },
                {
                    "app": {
                        "bundle_id": "com.sereisoglu.kedi",
                        "id": "a001",
                        "name": "Kedi"
                    },
                    "expires_date": null,
                    "is_in_introductory_price_period": false,
                    "is_renewal": false,
                    "is_sandbox": false,
                    "is_trial_conversion": false,
                    "is_trial_period": false,
                    "product_identifier": "kedi.supporter.monthly",
                    "purchase_date": "2024-02-07T03:00:00Z",
                    "revenue": 199.99,
                    "store": "App Store",
                    "store_transaction_identifier": "t002",
                    "subscriber_country_code": "TR",
                    "subscriber_id": "s002",
                    "subscriber_last_seen_platform": "iOS",
                    "was_refunded": false
                },
                {
                    "app": {
                        "bundle_id": "com.sereisoglu.kedi",
                        "id": "a001",
                        "name": "Kedi"
                    },
                    "expires_date": "2024-03-07T00:00:00Z",
                    "is_in_introductory_price_period": false,
                    "is_renewal": true,
                    "is_sandbox": false,
                    "is_trial_conversion": false,
                    "is_trial_period": true,
                    "product_identifier": "kedi.supporter.monthly",
                    "purchase_date": "2024-02-07T00:00:00Z",
                    "revenue": 1.99,
                    "store": "Stripe",
                    "store_transaction_identifier": "t003",
                    "subscriber_country_code": "US",
                    "subscriber_id": "s003",
                    "subscriber_last_seen_platform": "iOS",
                    "was_refunded": false
                },
                {
                    "app": {
                        "bundle_id": "com.sereisoglu.kedi",
                        "id": "a001",
                        "name": "Kedi"
                    },
                    "expires_date": "2024-02-07T20:00:00Z",
                    "is_in_introductory_price_period": false,
                    "is_renewal": true,
                    "is_sandbox": false,
                    "is_trial_conversion": false,
                    "is_trial_period": false,
                    "product_identifier": "kedi.supporter.monthly",
                    "purchase_date": "2024-02-06T20:00:00Z",
                    "revenue": 0.0,
                    "store": "Play Store",
                    "store_transaction_identifier": "t004",
                    "subscriber_country_code": "FR",
                    "subscriber_id": "s004",
                    "subscriber_last_seen_platform": "iOS",
                    "was_refunded": true
                },
                {
                    "app": {
                        "bundle_id": "com.sereisoglu.kedi",
                        "id": "a001",
                        "name": "Kedi"
                    },
                    "expires_date": "2025-02-06T18:00:00Z",
                    "is_in_introductory_price_period": false,
                    "is_renewal": true,
                    "is_sandbox": false,
                    "is_trial_conversion": false,
                    "is_trial_period": false,
                    "product_identifier": "kedi.supporter.monthly",
                    "purchase_date": "2024-02-06T18:00:00Z",
                    "revenue": 19.99,
                    "store": "App Store",
                    "store_transaction_identifier": "t005",
                    "subscriber_country_code": "PT",
                    "subscriber_id": "s005",
                    "subscriber_last_seen_platform": "iOS",
                    "was_refunded": false
                },
                {
                    "app": {
                        "bundle_id": "com.sereisoglu.kedi",
                        "id": "a001",
                        "name": "Kedi"
                    },
                    "expires_date": "2024-03-06T13:00:00Z",
                    "is_in_introductory_price_period": false,
                    "is_renewal": false,
                    "is_sandbox": false,
                    "is_trial_conversion": false,
                    "is_trial_period": false,
                    "product_identifier": "kedi.supporter.monthly",
                    "purchase_date": "2024-02-06T13:00:00Z",
                    "revenue": 2.99,
                    "store": "App Store",
                    "store_transaction_identifier": "t006",
                    "subscriber_country_code": "PL",
                    "subscriber_id": "s006",
                    "subscriber_last_seen_platform": "iOS",
                    "was_refunded": false
                },
                {
                    "app": {
                        "bundle_id": "com.sereisoglu.kedi",
                        "id": "a001",
                        "name": "Kedi"
                    },
                    "expires_date": "2025-02-05T17:00:00Z",
                    "is_in_introductory_price_period": false,
                    "is_renewal": true,
                    "is_sandbox": false,
                    "is_trial_conversion": false,
                    "is_trial_period": false,
                    "product_identifier": "kedi.supporter.monthly",
                    "purchase_date": "2024-02-05T17:00:00Z",
                    "revenue": 4.99,
                    "store": "App Store",
                    "store_transaction_identifier": "t007",
                    "subscriber_country_code": "FR",
                    "subscriber_id": "s007",
                    "subscriber_last_seen_platform": "iOS",
                    "was_refunded": false
                },
                {
                    "app": {
                        "bundle_id": "com.sereisoglu.kedi",
                        "id": "a001",
                        "name": "Kedi"
                    },
                    "expires_date": "2024-03-05T06:00:00Z",
                    "is_in_introductory_price_period": false,
                    "is_renewal": false,
                    "is_sandbox": false,
                    "is_trial_conversion": false,
                    "is_trial_period": false,
                    "product_identifier": "kedi.supporter.monthly",
                    "purchase_date": "2024-02-05T06:00:00Z",
                    "revenue": 2.99,
                    "store": "App Store",
                    "store_transaction_identifier": "t008",
                    "subscriber_country_code": "US",
                    "subscriber_id": "s008",
                    "subscriber_last_seen_platform": "iOS",
                    "was_refunded": false
                }
            ]
        }
        """#
        return try! JSONDecoder().decode(Self.self, from: .init(string.utf8))
    }()
}
