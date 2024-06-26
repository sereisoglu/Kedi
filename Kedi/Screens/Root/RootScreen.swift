//
//  RootScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct RootScreen: View {
    
    @EnvironmentObject var meManager: MeManager
    @EnvironmentObject var pushNotificationsManager: PushNotificationsManager
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    @State private var showingDeepLink: DeepLink?
    
    var body: some View {
        makeView()
            .onOpenURL { url in
                handleDeepLink(url: url)
            }
            .sheet(item: $showingDeepLink) { deepLink in
                makeView(deepLink: deepLink)
            }
    }
    
    @ViewBuilder
    private func makeView() -> some View {
        if meManager.isSignedIn {
            if pushNotificationsManager.isPermissionOpened {
                MainScreen()
            } else {
                NavigationStack {
                    NotificationsPermissionScreen()
                }
            }
        } else {
            if userDefaultsManager.isOnboardingOpened {
                NavigationStack {
                    SignInScreen()
                }
            } else {
                NavigationStack {
                    WelcomeScreen()
                }
            }
        }
    }
    
    private func handleDeepLink(url: URL) {
        guard let deepLink = DeepLink(url: url) else {
            print("Invalid deep link:", url.absoluteString)
            return
        }
        if showingDeepLink == nil {
            showingDeepLink = deepLink
        } else {
            showingDeepLink = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                showingDeepLink = deepLink
            }
        }
    }
    
    @ViewBuilder
    private func makeView(deepLink: DeepLink) -> some View {
        switch deepLink.item {
        case .transaction(let appId, let subscriberId):
            NavigationStack {
                TransactionDetailScreen(
                    viewModel: .init(appId: appId, subscriberId: subscriberId),
                    isPresented: true
                )
            }
        case .payday:
            NavigationStack {
                PaydayScreen(isPresented: true)
            }
        }
    }
}

#Preview {
    RootScreen()
}
