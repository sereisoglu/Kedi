//
//  MainScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct MainScreen: View {
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        makeView()
            .onAppear {
                requestReviewIfAppropriated()
            }
    }
    
    @ViewBuilder
    private func makeView() -> some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            TabBarScreen()
        } else {
            SidebarScreen()
        }
        #else
        SidebarScreen()
        #endif
    }
    
    @MainActor
    private func requestReviewIfAppropriated() {
        let isRequestReviewRequested = UserDefaults.standard.isRequestReviewRequested
        guard !isRequestReviewRequested else {
            return
        }
        let numberOfVisits = UserDefaults.standard.numberOfVisits + 1
        UserDefaults.standard.numberOfVisits = numberOfVisits
        guard numberOfVisits > 5 else {
            return
        }
        UserDefaults.standard.isRequestReviewRequested = true
        requestReview()
    }
}

#Preview {
    MainScreen()
}
