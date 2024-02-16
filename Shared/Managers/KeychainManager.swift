//
//  KeychainManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import Foundation
import KeychainSwift

final class KeychainManager {
    
    enum Key: String {
        case rcAuthToken
        case rcAuthTokenExpiresAt
    }
    
    private let keychain: KeychainSwift = {
        let keychain = KeychainSwift()
        keychain.accessGroup = "4K634X2CUP.keychain.com.sereisoglu.kedi"
        return keychain
    }()
    
    static let shared = KeychainManager()
    
    private init() {}
    
    func get(_ key: Key) -> String? {
        keychain.get(key.rawValue)
    }
    
    func set(
        _ value: String,
        forKey key: Key,
        withAccess access: KeychainSwiftAccessOptions? = nil
    ) {
        keychain.set(value, forKey: key.rawValue, withAccess: access)
    }
    
    func delete(_ key: Key) {
        keychain.delete(key.rawValue)
    }
}
