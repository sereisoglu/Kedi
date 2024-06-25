//
//  PaywallScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/17/24.
//

import SwiftUI

struct PaywallScreen: View {
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    private let analyticsManager = AnalyticsManager.shared
    
    @State private var subscriptionSelection: PurchaseProductType?
    @State private var showingAlert = false
    @State private var purchaseError: Error?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            makeBody()
        }
        .navigationTitle("Supporter")
        .background(Color.systemGroupedBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                CloseButton {
                    dismiss()
                }
            }
        }
        .if(purchaseManager.state == .data) { view in
            view.safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    if !purchaseManager.getSubscriptions().isEmpty,
                       let subscriptionSelection {
                        AsyncButton {
                            do {
                                try await purchaseManager.makePurchase(productType: subscriptionSelection)
                            } catch {
                                purchaseError = error
                                showingAlert = true
                            }
                        } label: {
                            Text("Subscribe Now")
                                .font(.body.bold())
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.accent)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        .disabled(purchaseManager.isPurchasing)
                        .padding(.top)
                        .padding(.horizontal)
                    }
                    
                    Text("[Restore Purchase](restore-purchase) • [Privacy Policy](https://kediapp.com/privacy-policy) • [Terms & Conditions](https://kediapp.com/terms-and-conditions)")
                        .font(.footnote)
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                        .environment(\.openURL, OpenURLAction(handler: { url in
                            if url.absoluteString == "restore-purchase" {
                                Task {
                                    do {
                                        try await purchaseManager.restorePurchase()
                                    } catch {
                                        purchaseError = error
                                        showingAlert = true
                                    }
                                }
                                return .handled
                            }
                            BrowserUtility.openUrlInApp(urlString: url.absoluteString)
                            return .handled
                        }))
                }
                .padding(.bottom)
                .background(.ultraThinMaterial)
                .overlay(Rectangle().frame(height: 1, alignment: .top).foregroundStyle(.primary.opacity(0.2)), alignment: .top)
            }
        }
        .overlay(content: makeStateView)
        .scrollContentBackground(purchaseManager.state == .data ? .automatic : .hidden)
        .background(Color.systemGroupedBackground)
        .disabled(purchaseManager.state == .loading)
        .alert(
            "Purchase Error",
            isPresented: $showingAlert
        ) {
            Button("OK!", role: .cancel) {}
        } message: {
            Text(purchaseError?.displayableLocalizedDescription ?? "An error has occurred.")
        }
        .onAppear {
            subscriptionSelection = purchaseManager.meSubscription?.productType.next ?? .supporterMonthly
        }
        .onReceive(purchaseManager.$meSubscription) { output in
            subscriptionSelection = output?.productType.next ?? .supporterMonthly
        }
        .onReceive(NotificationCenter.default.publisher(for: .purchase)) { output in
            if let productId = output.object as? String {
                analyticsManager.send(event: .purchase(productId: productId))
            }
        }
        .sensoryFeedback(.selection, trigger: purchaseManager.isPurchasing)
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        if purchaseManager.state == .data {
            if let meSubscription = purchaseManager.meSubscription {
                Section {
                    GeneralListView(
                        imageAsset: .systemImage("person"),
                        title: meSubscription.productType.name,
                        subtitle: meSubscription.purchaseDate.formatted(date: .abbreviated, time: .shortened),
                        accessoryImageSystemName: nil
                    )
                    
                    GeneralListView(
                        imageAsset: .systemImage("calendar"),
                        title: meSubscription.willRenew ? "Renews" : "Expires",
                        subtitle: meSubscription.expirationDate.formatted(date: .abbreviated, time: .shortened),
                        accessoryImageSystemName: nil
                    )
                    
                    Button {
                        Task {
                            do {
                                try await purchaseManager.showManageSubscriptions()
                            } catch {
                                purchaseError = error
                                showingAlert = true
                            }
                        }
                    } label: {
                        Text("Manage Your Subscriptions")
                    }
                } header: {
                    Text("Your Subscription")
                } footer: {
                    Text("You are eligible to use alternative app icons.\n❤️ Thanks for your support!")
                }
                
                if !purchaseManager.getSubscriptions().isEmpty {
                    Section {
                        VStack(spacing: 10) {
                            ForEach(purchaseManager.getSubscriptions()) { subscription in
                                makeSubscriptionView(subscription: subscription)
                            }
                        }
                        .listRowInsets(.zero)
                        .listRowBackground(Color.clear)
                    } header: {
                        Text("Upgrade Your Subscription")
                    }
                }
            } else {
                Section {
                    VStack(spacing: 10) {
                        ForEach(purchaseManager.getSubscriptions()) { subscription in
                            makeSubscriptionView(subscription: subscription)
                        }
                    }
                    .listRowInsets(.zero)
                    .listRowBackground(Color.clear)
                } header: {
                    Text("Subscriptions")
                } footer: {
                    Text("If you become a supporter, you are eligible to use alternative app icons.")
                }
            }
            
            Section {
                ForEach(purchaseManager.getNonSubscriptions()) { nonSubscription in
                    makeTipView(nonSubscription: nonSubscription)
                }
                
                if let totalSpent = purchaseManager.getNonSubscriptionsTotalSpent() {
                    Text("You've tipped \(totalSpent) so far.\n❤️ Thanks for your support!")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                } else {
                    Text("You haven't made a tip.")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
            } header: {
                Text("Tips")
            }
            
            Section {
            } footer: {
                Text("Subscription renews automatically, unless turned off in settings at least 24 hours before end of current period. Payment is charged to your Apple ID account.")
            }
        }
    }
    
    private func makeSubscriptionView(
        subscription: PurchaseModel
    ) -> some View {
        Button {
            subscriptionSelection = subscription.productType
        } label: {
            let isSelected = subscriptionSelection == subscription.productType
            
            HStack {
                VStack(alignment: .leading) {
                    Text(subscription.productType.name)
                    
                    Text("\(subscription.localizedPriceString) per month")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .fontWeight(.bold)
                }
            }
            .padding()
            .foregroundStyle(isSelected ? .white : .primary)
            .background(isSelected ? .accent : Color.secondarySystemGroupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                isSelected ? nil : RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(Color.primary.opacity(0.2), lineWidth: 2)
            )
        }
        .foregroundStyle(.primary)
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: subscriptionSelection)
    }
    
    private func makeTipView(
        nonSubscription: PurchaseModel
    ) -> some View {
        Label {
            Text(nonSubscription.productType.name)
            
            Spacer()
            
            AsyncButton {
                do {
                    try await purchaseManager.makePurchase(nonSubscription)
                } catch {
                    purchaseError = error
                    showingAlert = true
                }
            } label: {
                Text(nonSubscription.localizedPriceString)
                    .font(.body.bold())
                    .foregroundStyle(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(.accent)
                    .clipShape(Capsule())
            }
            .disabled(purchaseManager.isPurchasing)
        } icon: {
            Text(nonSubscription.productType.emoji)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func makeStateView() -> some View {
        switch purchaseManager.state {
        case .loading:
            ProgressView()
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .empty:
            ContentUnavailableView(
                "No Data",
                systemImage: "xmark.circle"
            )
            
        case .error(let error):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(error.displayableLocalizedDescription)
            )
            
        case .data:
            EmptyView()
        }
    }
}

#Preview {
    PaywallScreen()
        .environmentObject(PurchaseManager.shared)
}
