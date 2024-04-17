//
//  MainView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI
import StoreKit

struct MainView: View {
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            TabBarView()
                .onAppear {
                    requestReviewIfAppropriated()
                }
        } else {
            SidebarView()
                .onAppear {
                    requestReviewIfAppropriated()
                }
        }
        #else
        SidebarView()
            .onAppear {
                requestReviewIfAppropriated()
            }
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
    MainView()
}
