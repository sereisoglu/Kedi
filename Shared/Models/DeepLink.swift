//
//  DeepLink.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/26/24.
//

import Foundation

struct DeepLink: Identifiable {
    
    static let scheme = "kedi"
    
    enum Host: String {
        
        case payday
        
        var url: URL? {
            .init(string: "\(DeepLink.scheme)://\(rawValue)")
        }
    }
    
    var id: String { url.absoluteString }
    var url: URL
    var host: Host
    
    init?(url: URL) {
        guard url.scheme == Self.scheme,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let hostString = components.host,
              let host = Host(rawValue: hostString) else {
            return nil
        }
        
        self.url = url
        self.host = host
    }
    
    static func make(host: Host) -> URL? {
        host.url
    }
}
