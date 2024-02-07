//
//  TransactionDetailHistoryListView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import SwiftUI

struct TransactionDetailHistoryListView: View {
    
    let item: TransactionDetailHistoryItem
    
    var body: some View {
        switch item.type {
        case .installation,
                .lastSeen,
                .unknown:
            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .center, spacing: 6) {
                    Text(item.type.text)
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(item.type.color)
                    
                    Spacer()
                    
                    Text(item.date)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
        case .subscriberAlias(let alias):
            VStack(alignment: .leading, spacing: 3) {
                Text(item.type.text)
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(item.type.color)
                
                HStack(alignment: .center, spacing: 6) {
                    Text(alias)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(item.date)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .layoutPriority(1)
                }
            }
            
        case .cancellation(let price, let currency, let productIdentifier),
                .initialPurchase(let price, let currency, let productIdentifier),
                .oneTimePurchase(let price, let currency, let productIdentifier),
                .renewal(let price, let currency, let productIdentifier),
                .trial(let price, let currency, let productIdentifier),
                .conversion(let price, let currency, let productIdentifier),
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
                
                HStack(alignment: .center, spacing: 6) {
                    Text(productIdentifier)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(item.date)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    TransactionDetailHistoryListView(item: .init(data: .init()))
}
