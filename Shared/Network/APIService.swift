//
//  APIService.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation
import Alamofire

final class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    func setAuthToken(_ token: String?) {
        Endpoint.AUTH_TOKEN = token
    }
    
    func request<Success: Decodable>(_ endpoint: Endpoint) async throws -> Success {
        print("\n\(Date.now) \(endpoint.method.rawValue) \(endpoint.urlString)\nparameters: \(endpoint.printParameters ?? [:])\n")
        
        let dataRequest = AF.request(
            endpoint.urlString,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
        
        let response = await dataRequest.serializingData().response
        guard let statusCode = response.response?.statusCode else {
            print("API Request Error:", endpoint.urlString, "nilResponse")
            throw RCError.internal(.nilResponse)
        }
        guard let data = response.data else {
            print("API Request Error:", endpoint.urlString, "nilData")
            throw RCError.internal(.nilData)
        }
        
        switch statusCode {
        case 200 ..< 300:
            do {
                print("API Request Success:", endpoint.urlString)
                return try JSONDecoder.default.decode(Success.self, from: data)
            } catch {
                print("API Request Error:", endpoint.urlString, error)
                throw RCError.internal(.decoding(error))
            }
            
        default:
            do {
                let decodedData = try JSONDecoder.default.decode(RCErrorResponse.self, from: data)
                NotificationCenter.default.post(
                    name: .apiServiceRequestError,
                    object: RCError(error: decodedData)
                )
                print("API Request Error:", endpoint.urlString, String(decoding: data, as: UTF8.self))
                throw RCError(error: decodedData)
            } catch {
                if case let rcError as RCError = error {
                    throw rcError
                }
                print("API Request Error:", endpoint.urlString, error)
                throw RCError.internal(.decoding(error))
            }
        }
    }
    
    func download(urlString: String) async throws -> Data? {
        try await withUnsafeThrowingContinuation { continuation in
            let dataRequest = AF.request(urlString, method: .get)
            
            dataRequest.response { result in
                guard let response = result.response,
                      (200 ..< 300) ~= response.statusCode,
                      let data = result.data else {
                    continuation.resume(throwing: RCError.internal(.nilResponse))
                    return
                }
                
                continuation.resume(returning: data)
            }
        }
    }
}
