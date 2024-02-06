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
    
    func request<Success: Decodable>(
        type: Success.Type,
        endpoint: Endpoint
    ) async throws -> Success? {
        try await withUnsafeThrowingContinuation { continuation in
            let dataRequest = AF.request(
                endpoint.urlString,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers
            )
            
            dataRequest.response { result in
                if let error = result.error {
                    print("Request Error:", endpoint.urlString, error)
                    continuation.resume(throwing: RCError.internal(error))
                    return
                }
                
                guard let response = result.response else {
                    print("Request Error:", endpoint.urlString, "Nil Response")
                    continuation.resume(throwing: RCError.nilResponse)
                    return
                }
                
                guard (200 ..< 300) ~= response.statusCode else {
                    if let data = result.data {
                        do {
                            print("Request Error:", endpoint.urlString, String(decoding: data, as: UTF8.self))
                            let decodedData = try JSONDecoder().decode(RCErrorModel.self, from: data)
                            continuation.resume(throwing: RCError.service(decodedData))
                        } catch {
                            print("Request Error:", endpoint.urlString, error)
                            continuation.resume(throwing: RCError.decodeFailure(error))
                        }
                    } else {
                        print("Request Error:", endpoint.urlString, "Nil Error")
                        continuation.resume(throwing: RCError.nilData)
                    }
                    return
                }
                
                if let data = result.data {
                    do {
                        print("Request Success:", endpoint.urlString)
//                        print("Request Success:", endpoint.urlString, String(data: data, encoding: .utf8) ?? "")
                        let decodedData = try JSONDecoder().decode(Success?.self, from: data)
                        continuation.resume(returning: decodedData)
                    } catch {
                        print("Request Error:", endpoint.urlString, error)
                        continuation.resume(throwing: RCError.decodeSuccess(Success.self, error))
                    }
                } else {
                    print("Request Success:", endpoint.urlString, "nil")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
