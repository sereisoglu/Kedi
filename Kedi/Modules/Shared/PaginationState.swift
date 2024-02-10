//
//  PaginationState.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/10/24.
//

import Foundation

enum PaginationState: Equatable {
    
    case idle
    case paginating
    case error(Error)
    case done
    
    var id: Int {
        switch self {
        case .idle: 1
        case .paginating: 2
        case .error: 3
        case .done: 4
        }
    }
    
    static func == (lhs: PaginationState, rhs: PaginationState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
            (.paginating, .paginating),
            (.error, .error),
            (.done, .done):
            return true
        default:
            return false
        }
    }
}
