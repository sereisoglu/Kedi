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
    case projects
    case overview
    case charts(RCChartRequest)
    case transactions(RCTransactionsRequest)
    case transactionDetail(projectId: String, subscriberId: String)
    case transactionDetailActivity(projectId: String, subscriberId: String)
}

extension Endpoint {
    
    static var AUTH_TOKEN: String?
    
    var urlString: String {
        "\(baseUrl)/\(path)"
    }
    
    var baseUrl: String {
        switch self {
        case .projects,
                .transactionDetailActivity:
            return "https://api.revenuecat.com/internal/v1/developers"
        default:
            return "https://api.revenuecat.com/v1/developers"
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        case .me:
            return "me"
        case .projects:
            return "me/projects"
        case .overview:
            return "me/overview"
        case .charts(let request):
            return "me/charts_v2/\(request.name.rawValue)"
        case .transactions:
            return "me/transactions"
        case .transactionDetail(let projectId, let subscriberId):
            return "me/apps/\(projectId)/subscribers/\(subscriberId)"
        case .transactionDetailActivity(let projectId, let subscriberId):
            return "me/apps/\(projectId)/subscribers/\(subscriberId)/activity"
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
