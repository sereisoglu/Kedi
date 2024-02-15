//
//  TabBarView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selection: NavigationItem
    
    init() {
        selection = MeManager.shared.me == nil ? .settings : .overview
    }

    var body: some View {
        TabView(selection: $selection) {
            OverviewView()
                .tag(NavigationItem.overview)
                .tabItem {
                    makeTabItem(item: .overview)
                }
            
            TransactionsView()
                .tag(NavigationItem.transactions)
                .tabItem {
                    makeTabItem(item: .transactions)
                }
            
            SettingsView()
                .tag(NavigationItem.settings)
                .tabItem {
                    makeTabItem(item: .settings)
                }
        }
    }
    
    private func makeTabItem(
        item: NavigationItem
    ) -> some View {
        Label(item.title, systemImage: item.getIcon(isSelected: item == selection))
            .environment(\.symbolVariants, .none)
    }
}

#Preview {
    TabBarView()
}
