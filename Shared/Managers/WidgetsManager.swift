//
//  WidgetsManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/11/24.
//

import Foundation
import WidgetKit

final class WidgetsManager {
    
    private let widgetCenter = WidgetCenter.shared
    
    static let shared = WidgetsManager()
    
    private init() {}
    
    func reload(_ kinds: WidgetKind...) {
        kinds.forEach { kind in
            widgetCenter.reloadTimelines(ofKind: kind.rawValue)
        }
    }
    
    func reloadAll() {
        widgetCenter.reloadAllTimelines()
    }
}

enum WidgetKind: String {
    
    case overview = "OverviewWidget"
    case revenueGraph = "RevenueGraphWidget"
    case payday = "PaydayWidget"
}
