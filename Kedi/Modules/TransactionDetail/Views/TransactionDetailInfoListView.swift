//
//  TransactionDetailInfoListView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import SwiftUI

struct TransactionDetailInfoListView: View {
    
    let item: TransactionDetailInfoItem
    
    var body: some View {
        HStack {
            Text(item.key)
                .foregroundColor(.secondary)
                .font(.callout)
                .layoutPriority(1)
            
            Spacer()
            
            if item.copyable {
                Text(item.value)
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .contextMenu {
                        Button {
                            UIPasteboard.general.setValue(item.value, forPasteboardType: "public.plain-text")
                        } label: {
                            Label("Copy to clipboard", systemImage: "doc.on.doc")
                        }
                    }
            } else {
                Text(item.value)
                    .font(.callout)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    TransactionDetailInfoListView(item: .init(key: "", value: ""))
}
