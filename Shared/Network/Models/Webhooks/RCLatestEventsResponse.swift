//
//  RCLatestEventsResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/11/24.
//

import Foundation

struct RCLatestEventsResponse: Decodable {
    
    var events: [RCEvent]?
    
    enum CodingKeys: String, CodingKey {
        case events = "last_events"
    }
    
    init(events: [RCEvent]? = nil) {
        self.events = events
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let eventBodies = try container.decodeIfPresent([RCEventBody].self, forKey: .events)
        events = eventBodies?.compactMap(\.event)
    }
}

struct RCEventBody: Decodable {
    
    var event: RCEvent?
    
    enum CodingKeys: String, CodingKey {
        case requestBody = "request_body"
    }
    
    enum RequestBodyCodingKeys: String, CodingKey {
        case event
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let requestBodyContainer = try container.nestedContainer(keyedBy: RequestBodyCodingKeys.self, forKey: .requestBody)
        event = try requestBodyContainer.decodeIfPresent(RCEvent.self, forKey: .event)
    }
}

extension RCLatestEventsResponse {
    
    static let stub: Self = {
        let string = #"""
        {
            "last_events": [
                {
                    "attempt_count": 1,
                    "created_at": "2024-04-16T15:46:47Z",
                    "delivered_at": "2024-04-16T15:46:47Z",
                    "event_type": "webhook",
                    "integration_name": "Kedi",
                    "last_attempt_at": "2024-04-16T15:46:47Z",
                    "request_body": {
                        "api_version": "1.0",
                        "event": {
                            "aliases": [
                                "$RCAnonymousID:user0001"
                            ],
                            "app_id": "app001",
                            "app_user_id": "app_user0001",
                            "commission_percentage": 0.15,
                            "country_code": "US",
                            "currency": "USD",
                            "entitlement_id": null,
                            "entitlement_ids": [
                                "supporter"
                            ],
                            "environment": "PRODUCTION",
                            "event_timestamp_ms": 1713282343000,
                            "expiration_at_ms": 1713282343000,
                            "id": "uuid0001",
                            "is_family_share": false,
                            "offer_code": null,
                            "original_app_user_id": "$RCAnonymousID:user0001",
                            "original_transaction_id": "t0001",
                            "period_type": "NORMAL",
                            "presented_offering_id": "default",
                            "price": 1.99,
                            "price_in_purchased_currency": 1.99,
                            "product_id": "kedi.supporter.monthly",
                            "purchased_at_ms": 1713282343000,
                            "store": "APP_STORE",
                            "subscriber_attributes": {
                                "$displayName": {
                                    "updated_at_ms": 1713282343000,
                                    "value": "Ansley Castaneda"
                                },
                                "$email": {
                                    "updated_at_ms": 1713282343000,
                                    "value": "ansley@kediapp.com"
                                },
                                "username": {
                                    "updated_at_ms": 1713282343000,
                                    "value": "ansley"
                                }
                            },
                            "takehome_percentage": 0.85,
                            "tax_percentage": 0.0,
                            "transaction_id": "t0001",
                            "type": "INITIAL_PURCHASE"
                        }
                    },
                    "response_body": "success",
                    "response_code": 200,
                    "response_headers": null,
                    "updated_at": "2024-04-16T15:46:47Z",
                    "uuid": "uuid0001"
                },
                {
                    "attempt_count": 1,
                    "created_at": "2024-04-16T14:46:47Z",
                    "delivered_at": "2024-04-16T14:46:47Z",
                    "event_type": "webhook",
                    "integration_name": "Kedi",
                    "last_attempt_at": "2024-04-16T14:46:47Z",
                    "request_body": {
                        "api_version": "1.0",
                        "event": {
                            "aliases": [
                                "$RCAnonymousID:user0002"
                            ],
                            "app_id": "app001",
                            "app_user_id": "app_user0002",
                            "commission_percentage": 0.15,
                            "country_code": "US",
                            "currency": "USD",
                            "entitlement_id": null,
                            "entitlement_ids": [
                                "supporter"
                            ],
                            "environment": "PRODUCTION",
                            "event_timestamp_ms": 1713278743000,
                            "expiration_at_ms": 1713278743000,
                            "expiration_reason": "UNSUBSCRIBE",
                            "id": "uuid0002",
                            "is_family_share": false,
                            "offer_code": null,
                            "original_app_user_id": "$RCAnonymousID:user0002",
                            "original_transaction_id": "t0002",
                            "period_type": "NORMAL",
                            "presented_offering_id": "default",
                            "price": 0.0,
                            "price_in_purchased_currency": 0.0,
                            "product_id": "kedi.superSupporter.monthly",
                            "purchased_at_ms": 1713278743000,
                            "store": "APP_STORE",
                            "subscriber_attributes": {
                                "$displayName": {
                                    "updated_at_ms": 1713278743000,
                                    "value": "Flynn Vincent"
                                },
                                "$email": {
                                    "updated_at_ms": 1713278743000,
                                    "value": "flynnvincent@kediapp.com"
                                },
                                "username": {
                                    "updated_at_ms": 1713278743000,
                                    "value": "flynnvincent"
                                }
                            },
                            "takehome_percentage": 0.85,
                            "tax_percentage": 0.0,
                            "transaction_id": "t0002",
                            "type": "EXPIRATION"
                        }
                    },
                    "response_body": "success",
                    "response_code": 200,
                    "response_headers": null,
                    "updated_at": "2024-04-16T14:46:47Z",
                    "uuid": "uuid0002"
                },
                {
                    "attempt_count": 1,
                    "created_at": "2024-04-15T13:46:47Z",
                    "delivered_at": "2024-04-15T13:46:47Z",
                    "event_type": "webhook",
                    "integration_name": "Kedi",
                    "last_attempt_at": "2024-04-15T13:46:47Z",
                    "request_body": {
                        "api_version": "1.0",
                        "event": {
                            "aliases": [
                                "$RCAnonymousID:user0003"
                            ],
                            "app_id": "app001",
                            "app_user_id": "app_user0003",
                            "commission_percentage": 0.15,
                            "country_code": "US",
                            "currency": "USD",
                            "entitlement_id": null,
                            "entitlement_ids": [
                                "supporter"
                            ],
                            "environment": "PRODUCTION",
                            "event_timestamp_ms": 1713188743000,
                            "expiration_at_ms": 1713188743000,
                            "id": "uuid0003",
                            "is_family_share": false,
                            "is_trial_conversion": false,
                            "offer_code": null,
                            "original_app_user_id": "$RCAnonymousID:user0003",
                            "original_transaction_id": "t0003",
                            "period_type": "NORMAL",
                            "presented_offering_id": "default",
                            "price": 5.99,
                            "price_in_purchased_currency": 5.99,
                            "product_id": "kedi.superSupporter.monthly",
                            "purchased_at_ms": 1713188743000,
                            "store": "APP_STORE",
                            "subscriber_attributes": {
                                "$displayName": {
                                    "updated_at_ms": 1713188743000,
                                    "value": "Joanna Keller"
                                },
                                "$email": {
                                    "updated_at_ms": 1713188743000,
                                    "value": "keller@kediapp.com"
                                },
                                "username": {
                                    "updated_at_ms": 1713188743000,
                                    "value": "keller"
                                }
                            },
                            "takehome_percentage": 0.85,
                            "tax_percentage": 0.0,
                            "transaction_id": "t0003",
                            "type": "RENEWAL"
                        }
                    },
                    "response_body": "success",
                    "response_code": 200,
                    "response_headers": null,
                    "updated_at": "2024-04-15T13:46:47Z",
                    "uuid": "uuid0003"
                },
                {
                    "attempt_count": 1,
                    "created_at": "2024-04-15T12:46:47Z",
                    "delivered_at": "2024-04-15T12:46:47Z",
                    "event_type": "webhook",
                    "integration_name": "Kedi",
                    "last_attempt_at": "2024-04-15T12:46:47Z",
                    "request_body": {
                        "api_version": "1.0",
                        "event": {
                            "aliases": [
                                "$RCAnonymousID:user0004"
                            ],
                            "app_id": "app001",
                            "app_user_id": "app_user0004",
                            "commission_percentage": 0.1388,
                            "country_code": "TR",
                            "currency": "TRY",
                            "entitlement_id": null,
                            "entitlement_ids": [
                                "supporter"
                            ],
                            "environment": "PRODUCTION",
                            "event_timestamp_ms": 1713185143000,
                            "expiration_at_ms": 1713185143000,
                            "id": "uuid0004",
                            "is_family_share": false,
                            "is_trial_conversion": false,
                            "offer_code": null,
                            "original_app_user_id": "$RCAnonymousID:user0004",
                            "original_transaction_id": "t0004",
                            "period_type": "NORMAL",
                            "presented_offering_id": "default",
                            "price": 6.798,
                            "price_in_purchased_currency": 219.99,
                            "product_id": "kedi.fullSupporter.monthly",
                            "purchased_at_ms": 1713185143000,
                            "store": "APP_STORE",
                            "subscriber_attributes": {
                                "$displayName": {
                                    "updated_at_ms": 1713185143000,
                                    "value": "Leo Golden"
                                },
                                "$email": {
                                    "updated_at_ms": 1713185143000,
                                    "value": "leogolden@kediapp.com"
                                },
                                "username": {
                                    "updated_at_ms": 1713185143000,
                                    "value": "leogolden"
                                }
                            },
                            "takehome_percentage": 0.85,
                            "tax_percentage": 0.1949,
                            "transaction_id": "t0004",
                            "type": "NON_RENEWING_PURCHASE"
                        }
                    },
                    "response_body": "success",
                    "response_code": 200,
                    "response_headers": null,
                    "updated_at": "2024-04-15T12:46:47Z",
                    "uuid": "uuid0004"
                },
                {
                    "attempt_count": 1,
                    "created_at": "2024-04-14T11:46:47Z",
                    "delivered_at": "2024-04-14T11:46:47Z",
                    "event_type": "webhook",
                    "integration_name": "Kedi",
                    "last_attempt_at": "2024-04-14T11:46:47Z",
                    "request_body": {
                        "api_version": "1.0",
                        "event": {
                            "aliases": [
                                "$RCAnonymousID:user0005"
                            ],
                            "app_id": "app001",
                            "app_user_id": "app_user0005",
                            "commission_percentage": 0.15,
                            "country_code": "US",
                            "currency": "USD",
                            "entitlement_id": null,
                            "entitlement_ids": [
                                "supporter"
                            ],
                            "environment": "PRODUCTION",
                            "event_timestamp_ms": 1713095143000,
                            "expiration_at_ms": 1713095143000,
                            "id": "uuid0005",
                            "is_family_share": false,
                            "is_trial_conversion": false,
                            "offer_code": null,
                            "original_app_user_id": "$RCAnonymousID:user0005",
                            "original_transaction_id": "t0005",
                            "period_type": "NORMAL",
                            "presented_offering_id": "default",
                            "price": 2.99,
                            "price_in_purchased_currency": 2.99,
                            "product_id": "kedi.supporter.monthly",
                            "purchased_at_ms": 1713095143000,
                            "store": "APP_STORE",
                            "subscriber_attributes": {
                                "$displayName": {
                                    "updated_at_ms": 1713095143000,
                                    "value": "Astrid Dean"
                                },
                                "$email": {
                                    "updated_at_ms": 1713095143000,
                                    "value": "astriddean@kediapp.com"
                                },
                                "username": {
                                    "updated_at_ms": 1713095143000,
                                    "value": "astriddean"
                                }
                            },
                            "takehome_percentage": 0.85,
                            "tax_percentage": 0.0,
                            "transaction_id": "t0005",
                            "type": "RENEWAL"
                        }
                    },
                    "response_body": "success",
                    "response_code": 200,
                    "response_headers": null,
                    "updated_at": "2024-04-14T11:46:47Z",
                    "uuid": "uuid0005"
                },
                {
                    "attempt_count": 1,
                    "created_at": "2024-04-14T10:46:47Z",
                    "delivered_at": "2024-04-14T10:46:47Z",
                    "event_type": "webhook",
                    "integration_name": "Kedi",
                    "last_attempt_at": "2024-04-14T10:46:47Z",
                    "request_body": {
                        "api_version": "1.0",
                        "event": {
                            "aliases": [
                                "$RCAnonymousID:user0006"
                            ],
                            "app_id": "app001",
                            "app_user_id": "app_user0006",
                            "cancel_reason": "UNSUBSCRIBE",
                            "commission_percentage": 0.15,
                            "country_code": "US",
                            "currency": "USD",
                            "entitlement_id": null,
                            "entitlement_ids": [
                                "supporter"
                            ],
                            "environment": "PRODUCTION",
                            "event_timestamp_ms": 1713091543000,
                            "expiration_at_ms": 1713091543000,
                            "id": "uuid0006",
                            "is_family_share": false,
                            "offer_code": null,
                            "original_app_user_id": "$RCAnonymousID:user0006",
                            "original_transaction_id": "t0006",
                            "period_type": "NORMAL",
                            "presented_offering_id": "default",
                            "price": 0.0,
                            "price_in_purchased_currency": 0.0,
                            "product_id": "kedi.supporter.monthly",
                            "purchased_at_ms": 1713091543000,
                            "store": "APP_STORE",
                            "subscriber_attributes": {
                                "$displayName": {
                                    "updated_at_ms": 1713091543000,
                                    "value": "Jeffery Tucker"
                                },
                                "username": {
                                    "updated_at_ms": 1713091543000,
                                    "value": "jefferytucker"
                                }
                            },
                            "takehome_percentage": 0.85,
                            "tax_percentage": 0.0,
                            "transaction_id": "t0006",
                            "type": "CANCELLATION"
                        }
                    },
                    "response_body": "success",
                    "response_code": 200,
                    "response_headers": null,
                    "updated_at": "2024-04-14T10:46:47Z",
                    "uuid": "uuid0006"
                },
                {
                    "attempt_count": 1,
                    "created_at": "2024-04-13T09:46:47Z",
                    "delivered_at": "2024-04-13T09:46:47Z",
                    "event_type": "webhook",
                    "integration_name": "Kedi",
                    "last_attempt_at": "2024-04-13T09:46:47Z",
                    "request_body": {
                        "api_version": "1.0",
                        "event": {
                            "aliases": [
                                "$RCAnonymousID:user0007"
                            ],
                            "app_id": "app001",
                            "app_user_id": "app_user0007",
                            "commission_percentage": 0.15,
                            "country_code": "US",
                            "currency": "USD",
                            "entitlement_id": null,
                            "entitlement_ids": [
                                "supporter"
                            ],
                            "environment": "PRODUCTION",
                            "event_timestamp_ms": 1713001543000,
                            "expiration_at_ms": 1713001543000,
                            "id": "uuid0007",
                            "is_family_share": false,
                            "offer_code": null,
                            "original_app_user_id": "$RCAnonymousID:user0007",
                            "original_transaction_id": "t0007",
                            "period_type": "NORMAL",
                            "presented_offering_id": "default",
                            "price": 2.99,
                            "price_in_purchased_currency": 2.99,
                            "product_id": "kedi.supporter.monthly",
                            "purchased_at_ms": 1713001543000,
                            "store": "APP_STORE",
                            "subscriber_attributes": {
                                "$displayName": {
                                    "updated_at_ms": 1713001543000,
                                    "value": "Salem Kline"
                                },
                                "username": {
                                    "updated_at_ms": 1713001543000,
                                    "value": "salemkline"
                                }
                            },
                            "takehome_percentage": 0.85,
                            "tax_percentage": 0.0,
                            "transaction_id": "t0007",
                            "type": "INITIAL_PURCHASE"
                        }
                    },
                    "response_body": "success",
                    "response_code": 200,
                    "response_headers": null,
                    "updated_at": "2024-04-13T09:46:47Z",
                    "uuid": "uuid0007"
                },
                {
                    "attempt_count": 1,
                    "created_at": "2024-04-13T08:46:47Z",
                    "delivered_at": "2024-04-13T08:46:47Z",
                    "event_type": "webhook",
                    "integration_name": "Kedi",
                    "last_attempt_at": "2024-04-13T08:46:47Z",
                    "request_body": {
                        "api_version": "1.0",
                        "event": {
                            "aliases": [
                                "$RCAnonymousID:user0008"
                            ],
                            "app_id": "app001",
                            "app_user_id": "app_user0008",
                            "commission_percentage": 0.15,
                            "country_code": "US",
                            "currency": "USD",
                            "entitlement_id": null,
                            "entitlement_ids": [
                                "supporter"
                            ],
                            "environment": "PRODUCTION",
                            "event_timestamp_ms": 1712997943000,
                            "expiration_at_ms": 1712997943000,
                            "id": "uuid0008",
                            "is_family_share": false,
                            "is_trial_conversion": false,
                            "offer_code": null,
                            "original_app_user_id": "$RCAnonymousID:user0008",
                            "original_transaction_id": "t0008",
                            "period_type": "NORMAL",
                            "presented_offering_id": "default",
                            "price": 1.99,
                            "price_in_purchased_currency": 1.99,
                            "product_id": "kedi.supporter.monthly",
                            "purchased_at_ms": 1712997943000,
                            "store": "APP_STORE",
                            "subscriber_attributes": {
                                "$displayName": {
                                    "updated_at_ms": 1712997943000,
                                    "value": "Adonis Frederick"
                                },
                                "$email": {
                                    "updated_at_ms": 1712997943000,
                                    "value": "adonisfrederick@kediapp.com"
                                },
                                "username": {
                                    "updated_at_ms": 1712997943000,
                                    "value": "adonisfrederick"
                                }
                            },
                            "takehome_percentage": 0.85,
                            "tax_percentage": 0.0,
                            "transaction_id": "t0008",
                            "type": "RENEWAL"
                        }
                    },
                    "response_body": "success",
                    "response_code": 200,
                    "response_headers": null,
                    "updated_at": "2024-04-13T08:46:47Z",
                    "uuid": "uuid0008"
                }
            ]
        }
        """#
        return (try? JSONDecoder.default.decode(Self.self, from: .init(string.utf8))) ?? .init()
    }()
}
