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
                .foregroundStyle(.secondary)
                .font(.callout)
                .layoutPriority(1)
            
            Spacer()
            
            Text(item.value)
                .font(.callout)
                .foregroundStyle(.primary)
                .lineLimit(1)
                .if(item.copyable) { view in
                    view.textSelection(.enabled)
                }
        }
    }
}

#Preview {
    TransactionDetailInfoItemView(item: .init(key: "Id", value: "RC001", copyable: true))
}
