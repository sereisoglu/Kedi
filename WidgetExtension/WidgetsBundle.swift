//
//  WidgetsBundle.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI
import WidgetKit

@main
struct WidgetsBundle: WidgetBundle {
    
    var body: some Widget {
        OverviewWidget()
        DailyGraphWidget()
        PaydayWidget()
    }
}
