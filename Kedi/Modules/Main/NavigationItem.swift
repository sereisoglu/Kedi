//
//  NavigationItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

enum NavigationItem: Identifiable, Hashable {
    
    case overview
    case settings
    
    var id: UUID {
        UUID()
    }
    
    var icon: String {
        switch self {
        case .overview: "rectangle.grid.2x2"
        case .settings: "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .overview: "rectangle.grid.2x2.fill"
        case .settings: "gearshape.fill"
        }
    }
    
    var title: String {
        switch self {
        case .overview: "Overview"
        case .settings: "Settings"
        }
    }
    
    func getIcon(isSelected: Bool) -> String {
        isSelected ? selectedIcon : icon
    }
}
