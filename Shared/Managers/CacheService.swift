//
//  CacheService.swift
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

final class CacheService {
    
    private let storage: Storage<String, Data>? = {
        try? Storage<String, Data>(
            diskConfig: DiskConfig(name: "Floppy", expiry: .seconds(60 * 60 * 24 * 15), directory: .storeUrl(for: "group.com.sereisoglu.kedi", databaseName: "Cache")),
            memoryConfig: MemoryConfig(expiry: .never, countLimit: 1000, totalCostLimit: 1000),
            fileManager: .default,
            transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }()
    
    // FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.bundle.id")
    // try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("MyPreferences")
    
    static let shared = CacheService()
    private init() {}
    
    // MARK: - Get
    
    func getData(_ key: String) -> Data? {
        do {
            let entry = try storage?.entry(forKey: key)
            return (entry?.expiry.isExpired ?? true) ? nil : entry?.object
        } catch {
            //            print("CacheService: Get Error:", key, error)
            return nil
        }
    }
    
    func get<T: Codable>(_ key: String) -> T? {
        guard let data = getData(key) else { return nil }
        do {
            let decodedData = try JSONDecoder.default.decode(T.self, from: data)
            return decodedData
        } catch {
            //            print("CacheService: Decode Error:", T.self, key, error)
            return nil
        }
    }
    
    // MARK: - Set
    
    func setData(_ key: String, data: Data, expiry: Expiry? = nil) {
        print("\nCACHE SET:", key, "\n")
        do {
            try storage?.setObject(data, forKey: key, expiry: expiry)
        } catch {
            //            print("CacheService: Set Error:", key, error)
        }
    }
    
    func set<T: Codable>(_ key: String, data: T, expiry: Expiry? = nil) {
        do {
            let encodedData = try JSONEncoder.default.encode(data)
            setData(key, data: encodedData, expiry: expiry)
        } catch {
            //            print("CacheService: Encode Error:", T.self, key, error)
        }
    }
    
    // MARK: - Remove
    
    func remove(_ key: String) {
        do {
            try storage?.removeObject(forKey: key)
        } catch {
            //            print("CacheService: Remove Error:", key, error)
        }
    }
    
    func removeExpired() {
        do {
            try storage?.removeExpiredObjects()
        } catch {
            //            print("CacheService: Remove Expired Error:", error)
        }
    }
    
    func removeAll() {
        do {
            try storage?.removeAll()
        } catch {
            //            print("CacheService: Remove All Error:", error)
        }
    }
}
