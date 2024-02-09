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
    case unknown(RCErrorResponse)
    
    init(error: RCErrorResponse) {
        switch error.code {
        case 7002: self = .invalidEmailOrPassword(error)
        case 7224: self = .invalidAuthorizationToken(error)
        case 7667: self = .expiredAuthorizationToken(error)
        case 7008: self = .oneTimePasswordNeeded(error)
        case 7011: self = .invalidOneTimePassword(error)
        case 7632: self = .invalidXRequestedWithHeaderValue(error)
        case .none: fallthrough
        default: self = .unknown(error)
        }
    }
}

enum RCInternalError: Error {
    
    case error(Error)
    case nilResponse
    case nilError
    case decodeSuccess(Decodable.Type, Error)
    case decodeFailure(Error)
}

extension RCError {
    
    var message: String {
        switch self {
        case .internal(let internalError):
            return internalError.localizedDescription
        case .invalidEmailOrPassword(let error),
                .invalidAuthorizationToken(let error),
                .expiredAuthorizationToken(let error),
                .oneTimePasswordNeeded(let error),
                .invalidOneTimePassword(let error),
                .invalidXRequestedWithHeaderValue(let error),
                .unknown(let error):
            return error.message ?? "An unknown error has occurred."
        }
    }
}
