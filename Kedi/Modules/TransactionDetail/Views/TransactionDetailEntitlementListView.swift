//
//  TransactionDetailEntitlementListView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI

struct TransactionDetailEntitlementListView: View {
    
    let item: TransactionDetailEntitlementItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Text(item.type.status)
                .font(.body)
                .frame(width: 22, height: 22)
            
            VStack(alignment: .leading, spacing: 3) {
                Text("\(item.entitlementIdentifier) (\(item.productIdentifier))")
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(item.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    TransactionDetailEntitlementListView(item: .init(data: .init()))
}
