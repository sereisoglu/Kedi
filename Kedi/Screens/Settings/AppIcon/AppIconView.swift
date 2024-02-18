//
//  AppIconView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/13/24.
//

import SwiftUI

struct AppIconView: View {
    
    @AppStorage("appIcon") private var appIcon: AppIcon = .default
    
    @State private var appIconWidth: CGFloat = .zero
    @State private var appIconSelection: AppIcon = .default
    
    init() {
        appIconSelection = appIcon
    }
    
    var body: some View {
        List {
            ForEach(AppIcon.sections, id: \.self) { section in
                Section {
                    Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                        ForEach(AppIcon.allCases.filter { $0.section == section }.chunked(by: 3), id: \.self) { appIcons in
                            GridRow(alignment: .top) {
                                ForEach(appIcons, id: \.self) { appIcon in
                                    makeAppIcon(appIcon: appIcon)
                                }
                            }
                        }
                    }
                } header: {
                    Text(section)
                }
            }
        }
        .navigationTitle("App Icon")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func makeAppIcon(appIcon: AppIcon) -> some View {
        Button {
            self.appIcon = appIcon
            UIApplication.shared.setAlternateIconName(appIcon.identifier)
            self.appIconSelection = appIcon
        } label: {
            let isSelected = self.appIcon == appIcon
            
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
