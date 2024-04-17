//
//  CacheManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/9/24.
//

import Foundation
import Cache

extension URL {
    
    static func storeUrl(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        return fileContainer.appendingPathComponent(databaseName)
    }
}


final class CacheManager {
    
    private let storage: Storage<String, Data>? = {
        try? Storage<String, Data>(
            diskConfig: DiskConfig(name: "Floppy", expiry: .seconds(60 * 60 * 24 * 15), directory: .storeUrl(for: "group.com.sereisoglu.kedi", databaseName: "Cache")),
            memoryConfig: MemoryConfig(expiry: .never, countLimit: 1000, totalCostLimit: 1000),
            transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }()
    
    
    // FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.bundle.id")
//    try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("MyPreferences")
    
    static let shared = CacheManager()
    
    private init() {}
    
    // MARK: - Get
    
    func get(key: String) -> Data? {
        do {
            let entry = try storage?.entry(forKey: key)
            return (entry?.expiry.isExpired ?? true) ? nil : entry?.object
        } catch {
            //            print("CacheManager: Get Error:", key, error)
            return nil
        }
    }
    
    func getWithDecode<T: Codable>(key: String, type: T.Type) -> T? {
        do {
            if let data = get(key: key) {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            }
        } catch {
            //            print("CacheManager: Decode Error:", T.self, key, error)
        }
        return nil
    }
    
    // MARK: - Set
    
    func set(key: String, data: Data, expiry: Expiry? = nil) {
        print("\nCACHE SET:", key, "\n")
        do {
            try storage?.setObject(data, forKey: key, expiry: expiry)
        } catch {
            //            print("CacheManager: Set Error:", key, error)
        }
    }
    
    func setWithEncode<T: Codable>(key: String, data: T, expiry: Expiry? = nil) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            set(key: key, data: encodedData, expiry: expiry)
        } catch {
            //            print("CacheManager: Encode Error:", T.self, key, error)
        }
    }
    
    // MARK: - Remove
    
    func remove(key: String) {
        do {
            try storage?.removeObject(forKey: key)
        } catch {
            //            print("CacheManager: Remove Error:", key, error)
        }
    }
    
    func removeExpired() {
        do {
            try storage?.removeExpiredObjects()
        } catch {
            //            print("CacheManager: Remove Expired Error:", error)
        }
    }
    
    func removeAll() {
        do {
            try storage?.removeAll()
        } catch {
            //            print("CacheManager: Remove All Error:", error)
        }
    }
}
