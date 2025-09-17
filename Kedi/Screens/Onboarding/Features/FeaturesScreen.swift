//
//  FeaturesScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/23/24.
//

import SwiftUI

struct FeaturesScreen: View {
    
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    private let features: [Feature] = [
        .init(
            image: .Images.onboarding1,
            titleIcon: "square.grid.2x2",
            title: "Overview",
            description: "You can add charts you want, change their position and customize them."
        ),
        .init(
            image: .Images.onboarding2,
            titleIcon: "bell",
            title: "Notifications",
            description: "Add a webhook with just one tap to receive notifications of transactions in your projects."
        ),
        .init(
            image: .Images.onboarding3,
            titleIcon: "rectangle.3.group",
            title: "Widgets",
            description: "Overview, Revenue Graph, and App Store Payday."
        ),
        .init(
            image: .Images.onboarding4,
            titleIcon: "arrow.left.arrow.right.circle",
            title: "Transactions",
            description: "Shows transactions history."
        ),
        .init(
            image: .Images.onboarding5,
            titleIcon: "sparkles",
            title: "Insights",
            description: "Shows insights prepared specifically for your users."
        ),
        .init(
            image: .Images.onboarding6,
            titleIcon: "apple.logo",
            title: "App Store Payday",
            description: "Find out when you'll get paid from the App Store."
        )
    ]
    
    @State private var currentPage = 0
    
    var body: some View {
        VStack(spacing: 5) {
            TabView(selection: $currentPage) {
                ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                    FeatureView(feature: feature)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            PageControl(
                currentPage: $currentPage,
                numberOfPages: .constant(features.count)
            )
        }
        .padding(.bottom)
        .background(Color.systemGroupedBackground)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withOptionalAnimation {
                        userDefaultsManager.isOnboardingOpened = true
                    }
                } label: {
                    Text(currentPage == features.count - 1 ? "Done" : "Skip")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        FeaturesScreen()
    }
}
