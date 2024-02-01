//
//  RCError.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/1/24.
//

import Foundation

enum RCError: Error {
    
    case `internal`(Error)
    case nilResponse
    case nilData
    case decodeSuccess(Decodable.Type, Error)
    case decodeFailure(Error)
    case service(RCErrorModel)
}
