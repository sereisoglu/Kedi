//
//  NavigationItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

enum NavigationItem: String, Identifiable, Hashable, CaseIterable {
    
    case overview
    case transactions
    case settings
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .overview: "square.grid.2x2"
        case .transactions: "arrow.left.arrow.right.circle"
        case .settings: "gearshape"
        }
    }
    
    var title: String {
        switch self {
        case .overview: "Overview"
        case .transactions: "Transactions"
        case .settings: "Settings"
        }
    }
}
