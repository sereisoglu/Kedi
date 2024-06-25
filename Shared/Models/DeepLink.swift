//
//  DeepLink.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/26/24.
//

import Foundation

// xcrun simctl openurl booted 'kedi://payday'

struct DeepLink: Identifiable {
    
    static let scheme = "kedi"
    
    let id = UUID()
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

extension DeepLink {
    
    enum Item {
        
        case transaction(appId: String, subscriberId: String)
        case payday
        
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
            case .transaction: "transaction"
            case .payday: "payday"
            }
        }
        
        init?(url: URL) {
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let host = components.host else {
                return nil
            }
            
            let params = components.queryItems?.reduce([String: String](), { partialResult, queryItem in
                var partialResult = partialResult
                partialResult[queryItem.name] = queryItem.value
                return partialResult
            })
            
            switch host {
            case "transaction":
                guard let appId = params?["appId"],
                      let subscriberId = params?["subscriberId"] else {
                    return nil
                }
                self = .transaction(appId: appId, subscriberId: subscriberId)
                
            case "payday":
                self = .payday
                
            default:
                return nil
            }
        }
    }
}
