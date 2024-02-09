//
//  Endpoint.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation
import Alamofire

enum Endpoint {
    
    case login(RCLoginRequest)
    case me
    case overview
    case charts(RCChartRequest)
    case transactions(RCTransactionsRequest)
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
        case .charts(let request):
            return "developers/me/charts_v2/\(request.name.rawValue)"
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
        case .login(let request):
            return request.dict
        case .overview:
            return [
                "sandbox_mode": false
            ]
        case .charts(let request):
            return request.dict
        case .transactions(let request):
            return request.dict
        case .transactionDetail:
            return [
                "sandbox_mode": false
            ]
        case .transactionDetailActivity:
            return [
                "sandbox_mode": false
            ]
        default:
            return nil
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
        
        switch self {
        case .login:
            break
        default:
            if let authToken = Self.AUTH_TOKEN {
                headers.append(.authorization(bearerToken: authToken))
            }
        }
        
        return .init(headers)
    }
}
