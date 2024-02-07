//
//  TransactionDetailEntitlementItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI

struct TransactionDetailEntitlementItemView: View {
    
    let item: TransactionDetailEntitlementItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(item.type.status)
                .font(.footnote)
            
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
    TransactionDetailEntitlementItemView(item: .init(data: .init()))
}
