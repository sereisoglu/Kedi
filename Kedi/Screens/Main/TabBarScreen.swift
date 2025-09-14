//
//  TabBarScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import SwiftUI

struct TabBarScreen: View {
    
    @State private var selection: NavigationItem
    
    init() {
        selection = (MeManager.shared.me == nil || MeManager.shared.projects == nil) ? .settings : .overview
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                OverviewScreen()
            }
            .tag(NavigationItem.overview)
            .tabItem {
                makeTabItem(item: .overview)
            }
            
            NavigationStack {
                TransactionsScreen()
            }
            .tag(NavigationItem.transactions)
            .tabItem {
                makeTabItem(item: .transactions)
            }
            
            NavigationStack {
                NotificationsScreen()
            }
            .tag(NavigationItem.notifications)
            .tabItem {
                makeTabItem(item: .notifications)
            }
            
            NavigationStack {
                SettingsScreen()
            }
            .tag(NavigationItem.settings)
            .tabItem {
                makeTabItem(item: .settings)
            }
        }
    }
    
    private func makeTabItem(
        item: NavigationItem
    ) -> some View {
        Label(item.title, systemImage: item.icon)
    }
}

#Preview {
    TabBarScreen()
}
