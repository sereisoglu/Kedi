//
//  RCTransactionDetailResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import Foundation

struct RCTransactionDetailResponse: Decodable {
    
    var app: RCTransactionApp?
    var createdAt: String?
    var dollarsSpent: Double?
    var history: [RCSubscriberHistory]?
    var lastSeen: String?
    var lastSeenAppVersion: String?
    var lastSeenCountry: String?
    var lastSeenLocale: String?
    var lastSeenPlatform: String?
    var lastSeenPlatformVersion: String?
    var lastSeenSDKVersion: String?
    var subscriberAttributes: [RCSubscriberAttribute]?
    var subscriptionStatuses: [RCSubscriptionStatus]?
    
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
        
        app = try subscriberContainer.decodeIfPresent(RCTransactionApp.self, forKey: .app)
        createdAt = try subscriberContainer.decodeIfPresent(String.self, forKey: .createdAt)
        dollarsSpent = try subscriberContainer.decodeIfPresent(Double.self, forKey: .dollarsSpent)
        history = try subscriberContainer.decodeIfPresent([RCSubscriberHistory].self, forKey: .history)
        lastSeen = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeen)
        lastSeenAppVersion = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenAppVersion)
        lastSeenCountry = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenCountry)
        lastSeenLocale = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenLocale)
        lastSeenPlatform = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenPlatform)
        lastSeenPlatformVersion = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenPlatformVersion)
        lastSeenSDKVersion = try subscriberContainer.decodeIfPresent(String.self, forKey: .lastSeenSDKVersion)
        subscriberAttributes = try subscriberContainer.decodeIfPresent([RCSubscriberAttribute].self, forKey: .subscriberAttributes)
        
        let subscriptionStatusContainer = try subscriberContainer.nestedContainer(keyedBy: SubscriptionStatusCodingKeys.self, forKey: .subscriptionStatus)
        subscriptionStatuses = try subscriptionStatusContainer.decodeIfPresent([RCSubscriptionStatus].self, forKey: .live)
    }
}

struct RCSubscriberHistory: Decodable {
    
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

struct RCSubscriberAttribute: Decodable {
    
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

struct RCSubscriptionStatus: Decodable {
    
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
        
        let entitlements = try container.decodeIfPresent([RCSubscriptionStatusEntitlement].self, forKey: .entitlements)
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

struct RCSubscriptionStatusEntitlement: Decodable {
    
    var identifier: String?
}

extension RCTransactionDetailResponse {
    
    static let stub: Self = {
        let string = #"""
        {
            "subscriber": {
                "aliases": [
                    "aliase001"
                ],
                "app": {
                    "bundle_id": "com.sereisoglu.kedi",
                    "id": "app001",
                    "name": "Kedi",
                    "restore_behavior": "transfer"
                },
                "app_user_id": "$RCAnonymousID:anonymous001",
                "attribution_fields": null,
                "checkout_paywalls": [],
                "created_at": "2024-02-01T00:00:00Z",
                "dollars_spent": 99.99,
                "has_only_family_share_transactions": false,
                "history": [],
                "last_seen": "2024-02-01T00:00:00Z",
                "last_seen_alias": "aliase001",
                "last_seen_app_version": "1.0",
                "last_seen_country": "TR",
                "last_seen_identified_alias": "aliase001",
                "last_seen_locale": "en-US,en;q=0.9",
                "last_seen_mobile_app": {
                    "id": "app001",
                    "name": "Kedi",
                    "type": "app_store"
                },
                "last_seen_platform": "iOS",
                "last_seen_platform_flavor": "native",
                "last_seen_platform_version": "Version 17.2.1 (Build 21C66)",
                "last_seen_sdk_version": "4.32.0",
                "offering_override": null,
                "offering_override_source": null,
                "pay_paywalls": [],
                "price_experiment": null,
                "project": {
                    "icon_url": "https://www.appatar.io/com.sereisoglu.kedi/small",
                    "id": "app001",
                    "name": "Kedi"
                },
                "promotional_transactions": [],
                "restore_behavior": null,
                "subscriber_attributes": [
                    {
                        "key": "$email",
                        "value": {
                            "updated_at_ms": 1707577551000,
                            "value": "sereisoglu@gmail.com"
                        }
                    },
                    {
                        "key": "$apnsTokens",
                        "value": {
                            "updated_at_ms": 1707577551000,
                            "value": "N9TT-9G0A-B7FQ-RANC-N9TT-9G0A-B7FQ-RANC-N9TT-9G0A-B7FQ-RANC-N9TT-9G0A-B7FQ-RANC"
                        }
                    },
                    {
                        "key": "$displayName",
                        "value": {
                            "updated_at_ms": 1707577551000,
                            "value": "Saffet Emin Reisoğlu"
                        }
                    },
                    {
                        "key": "$attConsentStatus",
                        "value": {
                            "updated_at_ms": 1707577551000,
                            "value": "notDetermined"
                        }
                    }
                ],
                "subscription_status": {
                    "live": [
                        {
                            "billing_issues_detected_at": null,
                            "cancellation_date": null,
                            "entitlement_identifier": null,
                            "entitlements": [
                                {
                                    "created_at": "2024-02-01T00:00:00Z",
                                    "display_name": "Gain access to all features.",
                                    "id": "ent001",
                                    "identifier": "supporter",
                                    "products": [
                                        {
                                            "created_at": "2024-02-01T00:00:00Z",
                                            "id": "prod001",
                                            "identifier": "kedi.supporter.monthly",
                                            "store": "APP_STORE"
                                        }
                                    ]
                                }
                            ],
                            "expires_date": "2024-03-01T00:00:00Z",
                            "is_auto_renewing": true,
                            "is_trial": false,
                            "product_identifier": "kedi.supporter.monthly",
                            "purchase_date": "2024-02-01T00:00:00Z",
                            "refunded_at": null,
                            "store": "app_store",
                            "unsubscribe_detected_at": null
                        }
                    ],
                    "sandbox": []
                }
            }
        }
        """#
        
        return try! JSONDecoder().decode(Self.self, from: .init(string.utf8))
    }()
}

