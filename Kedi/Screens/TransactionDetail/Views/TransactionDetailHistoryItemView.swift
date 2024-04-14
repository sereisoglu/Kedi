//
//  TransactionDetailHistoryItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import SwiftUI

struct TransactionDetailHistoryItemView: View {
    
    let item: TransactionDetailHistoryItem
    
    var body: some View {
        switch item.type {
        case .installation,
                .lastSeen,
                .unknown:
            makeItem(
                title: item.type.text,
                titleTrailing: nil,
                subtitle: item.dateFormatted,
                description: nil,
                tag: nil
            )
            
        case .subscriberAlias(let alias):
            makeItem(
                title: item.type.text,
                titleTrailing: nil,
                subtitle: item.dateFormatted,
                description: alias,
                tag: nil
            )
            
        case .productChange(let productIdentifier):
            makeItem(
                title: item.type.text,
                titleTrailing: nil,
                subtitle: item.dateFormatted,
                description: productIdentifier,
                tag: nil
            )
            
        case .transfer(_, let id):
            makeItem(
                title: item.type.text,
                titleTrailing: nil,
                subtitle: item.dateFormatted,
                description: id,
                tag: nil
            )
            
        case .initialPurchase(let price, let currency, let productIdentifier),
                .oneTimePurchase(let price, let currency, let productIdentifier),
                .renewal(let price, let currency, let productIdentifier),
                .trial(let price, let currency, let productIdentifier),
                .conversion(let price, let currency, let productIdentifier),
                .resubscription(let price, let currency, let productIdentifier),
                .unsubscription(let price, let currency, let productIdentifier),
                .expiration(let price, let currency, let productIdentifier),
                .billingIssue(let price, let currency, let productIdentifier),
                .refund(let price, let currency, let productIdentifier):
            makeItem(
                title: item.type.text,
                titleTrailing: price.formatted(.currency(code: currency)),
                subtitle: item.dateFormatted,
                description: productIdentifier,
                tag: item.offerCode
            )
        }
    }
    
    private func makeItem(
        title: String,
        titleTrailing: String?,
        subtitle: String,
        description: String?,
        tag: String?
    ) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center, spacing: 6) {
                Text(title)
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(item.type.color)
                
                if let titleTrailing {
                    Spacer()
                    
                    Text(titleTrailing)
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(item.type.color)
                }
            }
            
            Text(subtitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .layoutPriority(1)
            
            if let description {
                Text(description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            if let tag {
                HStack {
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.primary.opacity(0.1))
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                .padding(.top, 2)
            }
        }
    }
}

#Preview {
    TransactionDetailHistoryItemView(item: .init(data: .stub, appUserId: "app_user001"))
}
