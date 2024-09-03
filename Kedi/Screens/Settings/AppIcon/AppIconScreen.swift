//
//  AppIconScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/13/24.
//

import SwiftUI

struct AppIconScreen: View {
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    @State private var appIconSelection = AppIcon.get()
    @State private var appIconWidth: CGFloat = .zero
    
    @State private var showingPaywall = false
    
    var body: some View {
        List {
            if purchaseManager.state == .data,
               purchaseManager.meSubscriptionType == .normal {
                Section {
                    BecomeSupporterView(
                        title: "Become a Supporter!",
                        subtitle: "Support indie development",
                        isActive: true
                    )
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                .listSectionSpacing(.custom(.zero))
            }
            
            ForEach(AppIcon.sections, id: \.self) { section in
                Section {
                    LazyVGrid(
                        columns: [.init(.adaptive(minimum: 90), alignment: .top)],
                        spacing: 12
                    ) {
                        ForEach(AppIcon.allCases.filter { $0.section == section }, id: \.self) { appIcon in
                            makeAppIcon(appIcon: appIcon)
                        }
                    }
                } header: {
                    Text(section)
                }
            }
        }
        .navigationTitle("App Icon")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingPaywall) {
            NavigationStack {
                PaywallScreen()
            }
        }
    }
    
    private func makeAppIcon(appIcon: AppIcon) -> some View {
        Button {
            if purchaseManager.meSubscriptionType != .normal {
                if appIconSelection != appIcon {
                    AppIcon.set(to: appIcon)
                    appIconSelection = appIcon
                }
            } else {
                showingPaywall.toggle()
            }
        } label: {
            let isSelected = appIconSelection == appIcon
            
            VStack(alignment: .center, spacing: 5) {
                Image(appIcon.preview)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: appIconWidth * (2 / 9), style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: appIconWidth * (2 / 9), style: .continuous)
                            .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1)
                    )
                    .getSize { size in
                        appIconWidth = size.width
                    }
                    .padding(5)
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: (appIconWidth + 10) * (2 / 9), style: .continuous)
                                .stroke(Color.accentColor, lineWidth: 3)
                        }
                    }
                
                Text(appIcon.name)
                    .font(.caption)
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                    .background(isSelected ? Color.accentColor : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: appIconSelection)
    }
}

#Preview {
    AppIconScreen()
}
