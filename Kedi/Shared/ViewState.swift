//
//  ViewState.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import Foundation

enum ViewState: Equatable, Hashable {
    
    case loading
    case empty
    case error(Error)
    case data
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
