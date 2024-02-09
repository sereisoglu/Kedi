//
//  Endpoint.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation
import Alamofire

enum Endpoint {
    
    case login(email: String, password: String)
    case me
    case overview
    case charts(name: RCChartName, resolution: RCChartResolution, startDate: String)
    case transactions
    case transactionDetail(appId: String, subscriberId: String)
    case transactionDetailActivity(appId: String, subscriberId: String)
}

extension Endpoint {
    
    static var AUTH_TOKEN: String?
    
    var urlString: String {
        "\(baseUrl)/\(path)"
    }
    
    var baseUrl: String {
        switch self {
        case .transactionDetailActivity: 
            return "https://api.revenuecat.com/internal/v1"
        default:
            return "https://api.revenuecat.com/v1"
        }
    }
    
    var path: String {
        switch self {
        case .login: 
            return "developers/login"
        case .me: 
            return "developers/me"
        case .overview:
            return "developers/me/overview"
        case .charts(let name, _, _):
            return "developers/me/charts_v2/\(name.rawValue)"
        case .transactions:
            return "developers/me/transactions"
        case .transactionDetail(let appId, let subscriberId):
            return "developers/me/apps/\(appId)/subscribers/\(subscriberId)"
        case .transactionDetailActivity(let appId, let subscriberId):
            return "developers/me/apps/\(appId)/subscribers/\(subscriberId)/activity"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login: .post
        default: .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .overview:
            return [
                "sandbox_mode": false
            ]
        case .charts(_, let resolution, let startDate):
            return [
                "resolution": resolution.rawValue,
                "start_date": startDate
            ]
        case .transactions:
            return [
                "sandbox_mode": false,
                "end_date": "2024-02-08",
                "limit": 100
            ]
        case .transactionDetail:
            return [
                "sandbox_mode": false
            ]
        case .transactionDetailActivity:
            return [
                "sandbox_mode": false
            ]
        default: return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login: JSONEncoding.default
        default: URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders? {
        var headers: [HTTPHeader] = [
            .init(name: "X-Requested-With", value: "XMLHttpRequest")
        ]
        
        if let authToken = Self.AUTH_TOKEN {
            headers.append(.authorization(bearerToken: authToken))
        }
        
        return .init(headers)
    }
}
