//
//  SupporterView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/17/24.
//

import SwiftUI

struct SupporterView: View {
    
    @State private var subscriptionSelection: PurchaseProductType = .supporterMonthly
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 10) {
                    ForEach(purchaseManager.getSubscriptions(), id: \.self) { subscription in
                        makeSubscriptionView(subscription: subscription)
                    }
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
            } header: {
                Text("Subsctiptions")
            } footer: {
                Text("Subscription renews automatically, unless turned off in settings at least 24 hours before end of current period. Payment is charged to your Apple ID account.")
            }
            
            Section {
                ForEach(purchaseManager.getNonSubscriptions(), id: \.self) { nonSubscription in
                    makeTipView(nonSubscription: nonSubscription)
                }
                
                Text("You haven't made a tip.")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            } header: {
                Text("Tips")
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                AsyncButton {
                    do {
                        try await purchaseManager.makePurchase(productType: subscriptionSelection)
                    } catch {
                        print(error)
                    }
                } label: {
                    Text("Subscribe Now")
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.accent)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(purchaseManager.isPurchasing)
                .padding()
                
                Text("[Restore Purchase](kedi://restore-purchase) • [Privacy Policy](https://github.com/sereisoglu/Kedi/blob/main/privacy-policy.md) • [Terms & Conditions](https://github.com/sereisoglu/Kedi/blob/main/terms-and-conditions.md)")
                    .font(.footnote)
                    .environment(\.openURL, OpenURLAction(handler: { url in
                        if url.absoluteString == "kedi://restore-purchase" {
                            Task {
                                do {
                                    try await purchaseManager.restorePurchase()
                                } catch {
                                    print(error)
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
        .navigationTitle("Supporter")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.selection, trigger: purchaseManager.isPurchasing)
        .toolbar {
            Button {
                dismiss()
            } label: {
                Text("Done")
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
                    print(error)
                }
            } label: {
                Text(nonSubscription.localizedPriceString)
                    .font(.body.bold())
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
}

#Preview {
    SupporterView()
}
