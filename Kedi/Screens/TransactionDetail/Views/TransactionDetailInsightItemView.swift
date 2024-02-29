//
//  TransactionDetailInsightItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/29/24.
//

import SwiftUI

struct TransactionDetailInsightItemView: View {
    
    @ScaledMetric private var emojiWidth: CGFloat = 18
    
    let item: TransactionDetailInsightItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(item.type.emoji)
                .font(.footnote)
                .frame(width: emojiWidth)
            
            Text(.init(item.text))
                .font(.callout)
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            viewDimensions[.listRowSeparatorLeading] + emojiWidth + 10
        }
    }
}

#Preview {
    TransactionDetailInsightItemView(item: .init(
        type: .firstPurchase,
        text: "The user made the first purchase **within 22 hours** of installing the app."
    ))
}
