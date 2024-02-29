//
//  TransactionDetailEntitlementItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI

struct TransactionDetailEntitlementItemView: View {
    
    @ScaledMetric private var emojiWidth: CGFloat = 18
    
    let item: TransactionDetailEntitlementItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(item.type.status)
                .font(.footnote)
                .frame(width: emojiWidth)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("\(item.entitlementIdentifier) (\(item.productIdentifier))")
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(item.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            viewDimensions[.listRowSeparatorLeading] + emojiWidth + 10
        }
    }
}

#Preview {
    TransactionDetailEntitlementItemView(item: .init(data: .init()))
}
