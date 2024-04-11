//
//  RCOverviewResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import Foundation

struct RCOverviewResponse: Decodable {
    
    var mrr: Double?
    var subscriptions: Int?
    var trials: Int?
    var revenue: Double?
    var users: Int?
    var installs: Int?
    
    enum CodingKeys: CodingKey {
        case metrics
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let metrics = try container.decodeIfPresent([RCOverviewMetric].self, forKey: .metrics)
        
        metrics?.forEach { metric in
            switch RCOverviewMetricType(rawValue: metric.id ?? "") {
            case .mrr:
                mrr = metric.value
            case .subscriptions:
                subscriptions = metric.value?.toInt
            case .trials:
                trials = metric.value?.toInt
            case .revenue:
                revenue = metric.value
            case .users:
                users = metric.value?.toInt
            case .installs:
                installs = metric.value?.toInt
            case .none:
                break
            }
        }
    }
}

struct RCOverviewMetric: Decodable {
    
    var id: String?
    var value: Double?
}

enum RCOverviewMetricType: String {
    
    case mrr
    case subscriptions = "active_subscriptions"
    case trials = "active_trials"
    case revenue
    case users = "active_users"
    case installs = "new_customers"
}

extension RCOverviewResponse {
    
    static let stub: Self = {
        let string = #"""
        {
          "load_strategy": "real_time_only",
          "metrics": [
            {
              "description": "In total",
              "id": "active_trials",
              "last_updated_at": null,
              "name": "Active Trials",
              "period": "P0D",
              "unit": "#",
              "value": 24
            },
            {
              "description": "In total",
              "id": "active_subscriptions",
              "last_updated_at": null,
              "name": "Active Subscriptions",
              "period": "P0D",
              "unit": "#",
              "value": 1140
            },
            {
              "description": "Monthly Recurring Revenue",
              "id": "mrr",
              "last_updated_at": null,
              "name": "MRR",
              "period": "P28D",
              "unit": "$",
              "value": 1239.97116721938576
            },
            {
              "description": "Last 28 days",
              "id": "revenue",
              "last_updated_at": null,
              "name": "Revenue",
              "period": "P28D",
              "unit": "$",
              "value": 9384.0915226693915
            },
            {
              "description": "Last 28 days",
              "id": "new_customers",
              "last_updated_at": null,
              "name": "New Customers",
              "period": "P28D",
              "unit": "#",
              "value": 7108
            },
            {
              "description": "Last 28 days",
              "id": "active_users",
              "last_updated_at": null,
              "name": "Active Users",
              "period": "P28D",
              "unit": "#",
              "value": 1037
            },
            {
              "description": "Last 28 days",
              "id": "num_tx_last_28_days",
              "last_updated_at": null,
              "name": "Number of transactions in the last 28 days",
              "period": "P28D",
              "unit": "#",
              "value": 0
            }
          ]
        }
        """#
        return try! JSONDecoder().decode(Self.self, from: .init(string.utf8))
    }()
}
