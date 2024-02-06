//
//  TransactionListView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import SwiftUI

struct TransactionListView: View {
    
    var transaction: TransactionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center, spacing: 6) {
                if let imageName = transaction.store?.imageName {
                    Image(imageName)
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
                    .foregroundStyle(transaction.color)
                
                Spacer()
                
                Text(transaction.price.formatted(.currency(code: "USD")))
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(transaction.color)
            }
            
            HStack(alignment: .center, spacing: 6) {
                if let appIconUrl = transaction.appIconUrl,
                   let url = URL(string: appIconUrl) {
                    CacheAsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Rectangle()
                            .foregroundStyle(.fill)
                    }
                    .frame(width: 22, height: 22)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                    )
                } else {
                    Rectangle()
                        .foregroundStyle(.fill)
                        .frame(width: 22, height: 22)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                        )
                }
                
                Text(transaction.appName)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(transaction.productIdentifier)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            HStack(alignment: .center, spacing: 6) {
                Text(transaction.countryFlag)
                    .font(.body)
                    .frame(width: 22, height: 22)
                
                Text(transaction.country)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                transaction.dateText
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            viewDimensions[.listRowSeparatorLeading] + 22 + 6
        }
    }
}

#Preview {
    TransactionListView(transaction: .init(data: .init()))
}
