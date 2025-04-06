//
//  TransactionItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import SwiftUI

struct TransactionItemView: View {
    
    let transaction: TransactionItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center, spacing: 10) {
                if let image = transaction.store?.image {
                    Image(image)
                        .resizable()
                        .frame(width: 22, height: 22)
                        .clipShape(Circle())
                } else {
                    Rectangle()
                        .foregroundStyle(.fill)
                        .frame(width: 22, height: 22)
                        .clipShape(Circle())
                }
                
                Text(transaction.type.text)
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(transaction.type.color)
                
                Spacer()
                
                Text(transaction.price.formatted(.currency(code: MeManager.shared.me?.displayCurrency ?? "USD")))
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(transaction.type.color)
            }
            
            HStack(alignment: .center, spacing: 10) {
                ImageWithPlaceholder(data: transaction.projectIcon) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(.fill)
                }
                .frame(width: 22, height: 22)
                .clipShape(RoundedRectangle(cornerRadius: 22 * (2 / 9), style: .continuous))
                
                Text(transaction.projectName)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(transaction.productIdentifier)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            HStack(alignment: .center, spacing: 10) {
                Text(transaction.countryFlag)
                    .font(.body)
                    .frame(width: 22, height: 22)
                
                Text(transaction.country)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(transaction.date)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            viewDimensions[.listRowSeparatorLeading] + 22 + 10
        }
    }
}

#Preview {
    TransactionItemView(transaction: .init(data: .init(), projectIcon: nil))
}
