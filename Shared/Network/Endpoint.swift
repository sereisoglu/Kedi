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
    case logout
    case me
    case projects
    case projectDetail(id: String)
    case overview(projectIds: [String]?)
    case charts(name: RCChartName, RCChartRequest)
    case transactions(RCTransactionsRequest)
    case transactionDetail(projectId: String, subscriberId: String)
    case transactionDetailActivity(projectId: String, subscriberId: String)
    case webhooks(projectId: String)
    case createWebhook(projectId: String, request: RCCreateWebhookRequest)
    case updateWebhook(projectId: String, webhookId: String, request: RCUpdateWebhookRequest)
    case deleteWebhook(projectId: String, webhookId: String)
    case testWebhook(projectId: String, webhookId: String)
    case latestEvents(projectId: String, webhookId: String)
}

extension Endpoint {
    
    static var AUTH_TOKEN: String?
    
    var urlString: String {
        "\(baseUrl)/\(path)"
    }
    
    var baseUrl: String {
        switch self {
        case .projects,
                .projectDetail,
                .transactionDetailActivity,
                .webhooks,
                .createWebhook,
                .updateWebhook,
                .deleteWebhook,
                .testWebhook,
                .latestEvents:
            return "https://api.revenuecat.com/internal/v1/developers"
        default:
            return "https://api.revenuecat.com/v1/developers"
        }
    }
    
    var path: String {
        switch self {
        case .login:
            "login"
        case .logout:
            "logout"
        case .me:
            "me"
        case .projects:
            "me/projects"
        case .projectDetail(let id):
            "me/projects/\(id)"
        case .overview:
            "me/charts_v2/overview"
        case .charts(let name, _):
            "me/charts_v2/\(name.rawValue)"
        case .transactions:
            "me/transactions"
        case .transactionDetail(let projectId, let subscriberId):
            "me/apps/\(projectId)/subscribers/\(subscriberId)"
        case .transactionDetailActivity(let projectId, let subscriberId):
            "me/apps/\(projectId)/subscribers/\(subscriberId)/activity"
        case .webhooks(let projectId):
            "me/projects/\(projectId)/integrations/webhooks"
        case .createWebhook(let projectId, _):
            "me/projects/\(projectId)/integrations/webhooks"
        case .updateWebhook(let projectId, let webhookId, _):
            "me/projects/\(projectId)/integrations/webhooks/\(webhookId)"
        case .deleteWebhook(let projectId, let webhookId):
            "me/projects/\(projectId)/integrations/webhooks/\(webhookId)"
        case .testWebhook(let projectId, let webhookId):
            "me/projects/\(projectId)/integrations/webhooks/\(webhookId)/test_webhook"
        case .latestEvents(let projectId, let webhookId):
            "me/projects/\(projectId)/integrations/webhooks/\(webhookId)/latest_events"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login,
                .logout,
                .createWebhook,
                .testWebhook:
            .post
        case .updateWebhook:
            .put
        case .deleteWebhook:
            .delete
        default:
            .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let request):
            return request.dict
        case .overview(let projectIds):
            if let projectIds {
                return [
                    "app_uuid": projectIds.joined(separator: "%2C")
                ]
            }
            return nil
        case .charts(_, let request):
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
        case .createWebhook(_, let request):
            return request.dict
        case .updateWebhook(_, _, let request):
            return request.dict
        case .latestEvents:
            return [
                "limit": 30
            ]
        default:
            return nil
        }
    }
    
    var printParameters: Parameters? {
        var params = parameters
        if params?["password"] != nil { params?["password"] = "•••••••••••••••" }
        return params
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login,
                .createWebhook,
                .updateWebhook:
            JSONEncoding.default
        default:
            URLEncoding.default
        }
    }
    
    var headers: HTTPHeaders? {
        var headers: [HTTPHeader] = [
            .init(name: "X-Requested-With", value: "XMLHttpRequest")
        ]
        
        if let authToken = Self.AUTH_TOKEN {
            headers.append(.authorization(bearerToken: authToken))
        }
        
        switch self {
        case .logout,
                .deleteWebhook,
                .testWebhook:
            headers.append(.contentType("application/json"))
        default:
            break
        }
        
        return .init(headers)
    }
}
