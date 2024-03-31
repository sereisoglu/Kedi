//
//  RootView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showingDeepLink: DeepLink?
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isSignedIn {
            MainView()
                .onOpenURL { url in
                    handleDeepLink(url: url)
                }
                .sheet(item: $showingDeepLink) { deepLink in
                    makeView(deepLink: deepLink)
                }
        } else {
            NavigationStack {
                SignInView()
            }
        }
    }
    
    private func handleDeepLink(url: URL) {
        guard let deepLink = DeepLink(url: url) else {
            print("Invalid deep link:", url.absoluteString)
            return
        }
        showingDeepLink = deepLink
    }
    
    @ViewBuilder
    private func makeView(deepLink: DeepLink) -> some View {
        switch deepLink.item {
        case .payday:
            NavigationStack {
                PaydayView(isPresented: true)
            }
        case .transaction(let appId, let subscriberId):
            NavigationStack {
                TransactionDetailView(viewModel: .init(appId: appId, subscriberId: subscriberId))
            }
        }
    }
}

#Preview {
    RootView()
}
