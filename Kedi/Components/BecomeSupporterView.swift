//
//  BecomeSupporterView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/19/24.
//

import SwiftUI

struct BecomeSupporterView: View {
    
    private let emojiWidth: CGFloat = 80
    
    @State private var showingPaywall = false
    
    var title: String
    var subtitle: String
    var isActive: Bool
//    var action: () -> Void
    
    var body: some View {
        Button {
//            action()
            showingPaywall.toggle()
        } label: {
            HStack(spacing: 0) {
                Text("🚀")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: emojiWidth - 2))
                    .frame(width: emojiWidth, height: 0)
                
                VStack(alignment: .center) {
                    Text(title)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
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
                .frame(width: emojiWidth)
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
        .sheet(isPresented: $showingPaywall) {
            NavigationStack {
                PaywallScreen()
            }
        }
    }
}

#Preview {
    Group {
        BecomeSupporterView(
            title: "You're a Super Supporter!",
            subtitle: "Support indie development",
            isActive: true
        )
        
        BecomeSupporterView(
            title: "You're a Super Supporter!",
            subtitle: "Support indie development",
            isActive: true
        )
        .environment(\.sizeCategory, .extraSmall)
        
        BecomeSupporterView(
            title: "Become a Supporter",
            subtitle: "Support indie development!",
            isActive: true
        )
        .environment(\.sizeCategory, .extraExtraExtraLarge)
    }
}
