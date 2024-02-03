//
//  TabBarView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView()
                .tag(0)
                .tabItem {
                    Label("Overview", systemImage: selectedTab == 0 ? "rectangle.grid.2x2.fill" : "rectangle.grid.2x2")
                }
            
            SettingsView()
                .tag(1)
                .tabItem {
                    Label("Settings", systemImage: selectedTab == 1 ? "gearshape.fill" : "gearshape")
                        .environment(\.symbolVariants, .none)
                }
        }
    }
}

#Preview {
    TabBarView()
}
