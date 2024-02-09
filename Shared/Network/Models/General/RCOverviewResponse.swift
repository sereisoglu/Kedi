//
//  RCOverviewResponse.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import Foundation

struct RCOverviewResponse: Decodable {
    
    var activeSubscribersCount: Int?
    var activeTrialsCount: Int?
    var activeUsersCount: Int?
    var installsCount: Int?
    var mrr: Double?
    var revenue: Double?
    
    enum CodingKeys: String, CodingKey {
        case activeSubscribersCount = "active_subscribers_count"
        case activeTrialsCount = "active_trials_count"
        case activeUsersCount = "active_users_count"
        case installsCount = "installs_count"
        case mrr = "mrr"
        case revenue = "revenue"
    }
}

extension RCOverviewResponse {

    static let stub: Self = {
        let string = #"""
        {"active_subscribers_count":1140,"active_trials_count":24,"active_users_count":5194,"installs_count":7108,"mrr":1239.97116721938576,"revenue":9384.0915226693915}
        """#

        let data = Data(string.utf8)

        return try! JSONDecoder().decode(Self.self, from: data)
    }()
}
