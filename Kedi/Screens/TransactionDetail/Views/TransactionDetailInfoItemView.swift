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
            
            if item.copyable {
                Text(item.value)
                    .font(.callout)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .contextMenu {
                        Button {
                            UIPasteboard.general.setValue(item.value, forPasteboardType: "public.plain-text")
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }
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
    TransactionDetailInfoItemView(item: .init(key: "", value: ""))
}
