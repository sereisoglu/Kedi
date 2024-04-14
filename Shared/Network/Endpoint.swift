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
    case charts(RCChartRequest)
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
            return "login"
        case .logout:
            return "logout"
        case .me:
            return "me"
        case .projects:
            return "me/projects"
        case .projectDetail(let id):
            return "me/projects/\(id)"
        case .overview:
            return "me/charts_v2/overview"
        case .charts(let request):
            return "me/charts_v2/\(request.name.rawValue)"
        case .transactions:
            return "me/transactions"
        case .transactionDetail(let projectId, let subscriberId):
            return "me/apps/\(projectId)/subscribers/\(subscriberId)"
        case .transactionDetailActivity(let projectId, let subscriberId):
            return "me/apps/\(projectId)/subscribers/\(subscriberId)/activity"
        case .webhooks(let projectId):
            return "me/projects/\(projectId)/integrations/webhooks"
        case .createWebhook(let projectId, _):
            return "me/projects/\(projectId)/integrations/webhooks"
        case .updateWebhook(let projectId, let webhookId, _):
            return "me/projects/\(projectId)/integrations/webhooks/\(webhookId)"
        case .deleteWebhook(let projectId, let webhookId):
            return "me/projects/\(projectId)/integrations/webhooks/\(webhookId)"
        case .testWebhook(let projectId, let webhookId):
            return "me/projects/\(projectId)/integrations/webhooks/\(webhookId)/test_webhook"
        case .latestEvents(let projectId, let webhookId):
            return "me/projects/\(projectId)/integrations/webhooks/\(webhookId)/latest_events"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login,
                .logout,
                .createWebhook,
                .testWebhook:
            return .post
        case .updateWebhook:
            return .put
        case .deleteWebhook:
            return .delete
        default:
            return .get
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
    
    var encoding: ParameterEncoding {
        switch self {
        case .login,
                .createWebhook,
                .updateWebhook:
            return JSONEncoding.default
        default:
            return URLEncoding.default
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
