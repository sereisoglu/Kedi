//
//  UIState.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import Foundation

enum UIState: Equatable {
    case loading
    case empty
    case error(Error)
    case data
    
    static func == (lhs: UIState, rhs: UIState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
                (.empty, .empty),
                (.error, .error),
                (.data, .data):
            return true
        default:
            return false
        }
    }
}
