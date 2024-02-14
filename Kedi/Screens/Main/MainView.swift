//
//  MainView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct MainView: View {
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            TabBarView()
        } else {
            SidebarView()
        }
        #else
        SidebarView()
        #endif
    }
}

#Preview {
    MainView()
}
