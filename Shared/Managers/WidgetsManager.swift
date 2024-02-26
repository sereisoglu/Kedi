//
//  WidgetsManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/11/24.
//

import Foundation
import WidgetKit

final class WidgetsManager {
    
    static let shared = WidgetsManager()
    
    private init() {}
    
    func reload(_ kinds: WidgetKind...) {
        kinds.forEach { kind in
            WidgetCenter.shared.reloadTimelines(ofKind: kind.rawValue)
        }
    }
    
    func reloadAll() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

enum WidgetKind: String {
    
    case overview = "OverviewWidget"
    case dailyGraph = "DailyGraphWidget"
    case payday = "PaydayWidget"
}
