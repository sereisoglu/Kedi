//
//  GeneralListView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/15/24.
//

import SwiftUI

struct GeneralListView: View {
    
    enum ImageAsset {
        
        case systemImage(String)
        case emoji(String)
        case custom(String)
    }
    
    @ScaledMetric private var imageWidth: CGFloat = 30
    
    var imageAsset: ImageAsset
    var title: String
    var subtitle: String?
    var accessoryImageSystemName: String? = "chevron.forward"
    
    var body: some View {
        Label {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .tint(.primary)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .tint(.secondary)
                    }
                }
                
                Spacer()
                
                if let accessoryImageSystemName {
                    Image(systemName: accessoryImageSystemName)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.tertiaryLabel)
                        .tint(.tertiaryLabel)
//                        .padding(.leading, 2)
                }
            }
        } icon: {
            switch imageAsset {
            case .systemImage(let name):
                Image(systemName: name)
                    .font(.body)
                    .foregroundStyle(Color.accentColor)
                    .imageScale(.large)
                    .frame(width: imageWidth, height: imageWidth)
                
            case .emoji(let emoji):
                Text(emoji)
                    .frame(width: imageWidth, height: imageWidth)
                
            case .custom(let name):
                Image(name)
                    .resizable()
                    .foregroundStyle(Color.accentColor)
                    .frame(width: imageWidth, height: imageWidth)
            }
        }
        .labelStyle(CenterAlignedLabelStyle())
    }
}

#Preview {
    GeneralListView(
        imageAsset: .systemImage("star"),
        title: "Rate Kedi",
        subtitle: "Rate us on the App Store – it really helps!",
        accessoryImageSystemName: "arrow.up.right"
    )
}
