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
    case overview
}

extension Endpoint {
    
    static let BASE_URL = "https://api.revenuecat.com"
    static var AUTH_TOKEN: String?
    
    var urlString: String {
        "\(Self.BASE_URL)/\(version)/\(path)"
    }
    
    var version: String {
        "v1"
    }
    
    var path: String {
        switch self {
        case .login: "developers/login"
        case .overview: "developers/me/overview"
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
