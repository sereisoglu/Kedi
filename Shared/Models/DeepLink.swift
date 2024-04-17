//
//  DeepLink.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/26/24.
//

import Foundation

struct DeepLink: Identifiable {
    
    enum Item {
        
        case payday
        case transaction(appId: String, subscriberId: String)
        
        var url: URL? {
            var params: String?
            switch self {
            case .transaction(let appId, let subscriberId):
                params = "appId=\(appId)&subscriberId=\(subscriberId)"
            default:
                break
            }
            
            if let params {
                return URL(string: "\(DeepLink.scheme)://\(host)?\(params)")
            } else {
                return URL(string: "\(DeepLink.scheme)://\(host)")
            }
        }
        
        var host: String {
            switch self {
            case .payday: "payday"
            case .transaction: "transaction"
            }
        }
        
        init?(url: URL) {
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let host = components.host else {
                return nil
            }
            
            let params = components.queryItems?.reduce([String : Any](), { partialResult, queryItem in
                var partialResult = partialResult
                partialResult[queryItem.name] = queryItem.value
                return partialResult
            })
            
            switch host {
            case "payday":
                self = .payday
                
            case "transaction":
                guard let appId = params?["appId"] as? String,
                      let subscriberId = params?["subscriberId"] as? String else {
                    return nil
                }
                self = .transaction(appId: appId, subscriberId: subscriberId)
                
            default:
                return nil
            }
        }
    }
    
    static let scheme = "kedi"
    
    var id: String { url.absoluteString }
    var url: URL
    var item: Item
    
    init?(url: URL) {
        guard url.scheme == Self.scheme,
              let item = Item(url: url) else {
            return nil
        }
        self.url = url
        self.item = item
    }
    
    static func make(item: Item) -> URL? {
        item.url
    }
}
