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
            VStack(alignment: .leading, spacing: 3) {
                Text(item.type.text)
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(item.type.color)
                
                Text(item.dateText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
        case .subscriberAlias(let alias):
            descriptionView(item: item, description: alias)
            
        case .productChange(let productIdentifier):
            descriptionView(item: item, description: productIdentifier)
            
        case .transfer(_, let id):
            descriptionView(item: item, description: id)
            
        case .initialPurchase(let price, let currency, let productIdentifier),
                .oneTimePurchase(let price, let currency, let productIdentifier),
                .renewal(let price, let currency, let productIdentifier),
                .trial(let price, let currency, let productIdentifier),
                .conversion(let price, let currency, let productIdentifier),
                .resubscribed(let price, let currency, let productIdentifier),
                .unsubscribed(let price, let currency, let productIdentifier),
                .expiration(let price, let currency, let productIdentifier),
                .billingIssue(let price, let currency, let productIdentifier),
                .refund(let price, let currency, let productIdentifier):
            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .center, spacing: 6) {
                    Text(item.type.text)
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(item.type.color)
                    
                    Spacer()
                    
                    Text(price.formatted(.currency(code: currency)))
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(item.type.color)
                }
                
                Text(item.dateText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .layoutPriority(1)
                
                Text(productIdentifier)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                if let offerCode = item.offerCode {
                    HStack {
                        Text("Offer Code: \(offerCode)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func descriptionView(
        item: TransactionDetailHistoryItem,
        description: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(item.type.text)
                .font(.system(.body, weight: .semibold))
                .foregroundStyle(item.type.color)
            
            Text(item.dateText)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .layoutPriority(1)
            
            Text(description)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

//#Preview {
//    TransactionDetailHistoryItemView(item: )
//}
