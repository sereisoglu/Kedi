//
//  RCError.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation

enum RCError: Error {
    
    case `internal`(RCInternalError)
    case invalidEmailOrPassword(RCErrorResponse)
    case invalidAuthorizationToken(RCErrorResponse)
    case expiredAuthorizationToken(RCErrorResponse)
    case oneTimePasswordNeeded(RCErrorResponse)
    case invalidOneTimePassword(RCErrorResponse)
    case invalidXRequestedWithHeaderValue(RCErrorResponse)
    case tooManyRequests(RCErrorResponse)
    case unknown(RCErrorResponse)
    
    init(error: RCErrorResponse) {
        switch error.code {
        case 7002: self = .invalidEmailOrPassword(error)
        case 7224: self = .invalidAuthorizationToken(error)
        case 7667: self = .expiredAuthorizationToken(error)
        case 7008: self = .oneTimePasswordNeeded(error)
        case 7011: self = .invalidOneTimePassword(error)
        case 7632: self = .invalidXRequestedWithHeaderValue(error)
        case 7114: self = .tooManyRequests(error)
        case .none: fallthrough
        default: self = .unknown(error)
        }
    }
}

extension RCError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .internal(let internalError):
            return internalError.localizedDescription
        case .invalidEmailOrPassword(let error),
                .invalidAuthorizationToken(let error),
                .expiredAuthorizationToken(let error),
                .oneTimePasswordNeeded(let error),
                .invalidOneTimePassword(let error),
                .invalidXRequestedWithHeaderValue(let error),
                .tooManyRequests(let error),
                .unknown(let error):
            return error.message ?? "An unknown error has occurred."
        }
    }
}

enum RCInternalError: Error {
    
    case error(Error)
    case network(Error)
    case decoding(Error)
    case nilResponse
    case nilData
    case unknown
}

extension RCInternalError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .error: "Error."
        case .network: "Network error occurred."
        case .decoding: "Failed to decode response."
        case .nilResponse: "No response from server."
        case .nilData: "No data received."
        case .unknown: "An unknown error occurred."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .error(let error): error.localizedDescription
        case .network(let error): error.localizedDescription
        case .decoding(let error): error.localizedDescription
        case .nilResponse: "Please try again."
        case .nilData: "Please try again."
        case .unknown: "Please try again."
        }
    }
}
