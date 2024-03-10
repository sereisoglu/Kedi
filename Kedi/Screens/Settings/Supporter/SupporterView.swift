//
//  SupporterView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/17/24.
//

import SwiftUI

struct SupporterView: View {
    
    @State private var subscriptionSelection: PurchaseProductType?
    @State private var showingAlert = false
    @State private var purchaseError: Error?
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var body: some View {
        makeBody()
            .navigationTitle("Supporter")
            .background(Color.systemGroupedBackground)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss", role: .cancel) { dismiss() }
                }
            }
            .sensoryFeedback(.selection, trigger: purchaseManager.isPurchasing)
            .onAppear {
                subscriptionSelection = Self.getDefaultSubscriptionSelection(productType: purchaseManager.meSubscription?.productType)
            }
            .onReceive(purchaseManager.$meSubscription) { output in
                subscriptionSelection = Self.getDefaultSubscriptionSelection(productType: output?.productType)
            }
            .alert(
                "Purchase Error",
                isPresented: $showingAlert
            ) {
                Button("OK!", role: .cancel) {}
            } message: {
                Text(purchaseError?.localizedDescription ?? "An error has occurred.")
            }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
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
                description: Text(error.localizedDescription)
            )
            
        case .data:
            List {
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
                                .foregroundStyle(.blue)
                        }
                    } header: {
                        Text("Your Subsctiption")
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
                            Text("Upgrade")
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
                        Text("Subsctiptions")
                    } footer: {
                        Text("If you become a supporter, you are eligible to use alternative app icons.")
                    }
                }
                
                Section {
                    ForEach(purchaseManager.getNonSubscriptions()) { nonSubscription in
                        makeTipView(nonSubscription: nonSubscription)
                    }
                    
                    Text(purchaseManager.getTotalSpentForTips())
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                } header: {
                    Text("Tips")
                }
                
                Section {
                } footer: {
                    Text("Kedi is a free and [open-source \(Text(imageSystemName: "arrow.up.forward").foregroundStyle(.accent))](https://github.com/sereisoglu/Kedi) RevenueCat client. Kedi was build by a solo [developer \(Text(imageSystemName: "arrow.up.forward").foregroundStyle(.accent))](https://x.com/sereisoglu).\n\nSubscription renews automatically, unless turned off in settings at least 24 hours before end of current period. Payment is charged to your Apple ID account.")
                }
            }
            .safeAreaInset(edge: .bottom) {
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

                    Text("[Restore Purchase](kedi://restore-purchase) • [Privacy Policy](https://kediapp.com/privacy-policy) • [Terms & Conditions](https://kediapp.com/terms-and-conditions)")
                        .font(.footnote)
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                        .environment(\.openURL, OpenURLAction(handler: { url in
                            if url.absoluteString == "kedi://restore-purchase" {
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
    
    static private func getDefaultSubscriptionSelection(
        productType: PurchaseProductType?
    ) -> PurchaseProductType? {
        switch productType {
        case .supporterMonthly:
            return .fullSupporterMonthly
        case .fullSupporterMonthly:
            return .superSupporterMonthly
        case .superSupporterMonthly:
            return nil
        case .none:
            fallthrough
        default:
            return .supporterMonthly
        }
    }
}

#Preview {
    SupporterView()
}
