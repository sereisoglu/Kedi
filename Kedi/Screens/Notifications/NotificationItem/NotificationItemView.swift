//
//  NotificationItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/14/24.
//

import SwiftUI

struct NotificationItemView: View {
    
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center, spacing: 10) {
                if let image = notification.store?.image {
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
                
                Text(notification.type.text)
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(notification.type.color)
                
                Spacer()
                
                if let price = notification.price {
                    Text(price.formatted(.currency(code: "USD")))
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(notification.type.color)
                }
            }
            
            HStack(alignment: .center, spacing: 10) {
                ImageWithPlaceholder(data: notification.projectIcon) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(.fill)
                }
                .frame(width: 22, height: 22)
                .clipShape(RoundedRectangle(cornerRadius: 22 * (2 / 9), style: .continuous))
                
                Text(notification.projectName)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if let productIdentifier = notification.productIdentifier {
                    Text(productIdentifier)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            if let subscriberAttributes = notification.subscriberAttributes {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "person")
                        .font(.body)
                        .frame(width: 22, height: 22)
                    
                    Text(subscriberAttributes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack(alignment: .center, spacing: 10) {
                Text(notification.countryFlag)
                    .font(.body)
                    .frame(width: 22, height: 22)
                
                Text(notification.country)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(notification.formattedDate)
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
    NotificationItemView(notification: .init(data: .init(), project: .init(id: "", name: "")))
}
