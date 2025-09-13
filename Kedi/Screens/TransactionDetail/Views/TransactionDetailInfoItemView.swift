//
//  TransactionDetailInfoItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import SwiftUI

struct TransactionDetailInfoItemView: View {
    
    let item: TransactionDetailInfoItem
    
    var body: some View {
        HStack {
            Text(item.key)
                .font(.callout)
                .foregroundStyle(.secondary)
                .layoutPriority(1)
            
            Spacer()
            
            if item.copyable {
                Text(item.value)
                    .font(.callout)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .textSelection(.enabled)
            } else {
                Text(item.value)
                    .font(.callout)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    TransactionDetailInfoItemView(item: .init(key: "Id", value: "RC001", copyable: true))
}
