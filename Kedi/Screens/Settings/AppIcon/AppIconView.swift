//
//  AppIconView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/13/24.
//

import SwiftUI

struct AppIconView: View {
    
    @State private var appIconSelection: AppIcon {
        didSet {
            UserDefaults.standard.appIcon = appIconSelection.rawValue
        }
    }
    
    @State private var appIconWidth: CGFloat = .zero
    @State private var showingSupporter = false
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    
    init() {
        appIconSelection = .init(rawValue: UserDefaults.standard.appIcon ?? "AppIcon") ?? .default
    }
    
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
        .sheet(isPresented: $showingSupporter) {
            NavigationStack {
                SupporterView()
            }
        }
    }
    
    private func makeAppIcon(appIcon: AppIcon) -> some View {
        Button {
            if purchaseManager.meSubscriptionType != .normal {
                if appIconSelection != appIcon {
                    UIApplication.shared.setAlternateIconName(appIcon.identifier)
                    appIconSelection = appIcon
                }
            } else {
                showingSupporter.toggle()
            }
        } label: {
            let isSelected = appIconSelection == appIcon
            
            VStack(alignment: .center, spacing: 5) {
                Image(uiImage: appIcon.uiImage)
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
    AppIconView()
}
