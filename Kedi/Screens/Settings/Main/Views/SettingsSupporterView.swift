//
//  SettingsSupporterView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/19/24.
//

import SwiftUI

struct SettingsSupporterView: View {
    
    @ScaledMetric private var imageWidth: CGFloat = 80
    
    var title: String
    var subtitle: String
    var isActive: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 0) {
                Text("🚀")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: imageWidth - 2))
                    .frame(width: imageWidth, height: 0)
                
                VStack(alignment: .center) {
                    Text(title)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                HStack() {
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
                .padding(.trailing)
                .frame(width: imageWidth)
            }
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isActive ? .accent : Color.secondarySystemGroupedBackground)
            }
            .foregroundStyle(isActive ? .white : .primary)
        }
        .buttonStyle(.plain)
        .padding(.vertical)
    }
}

#Preview {
    SettingsSupporterView(
        title: "Become a Supporter",
        subtitle: "Support indie development!",
        isActive: true,
        action: {}
    )
}
