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
        case custom(String)
    }
    
    @ScaledMetric private var imageWidth: CGFloat = 22
    
    var imageAsset: ImageAsset
    var title: String
    var subtitle: String?
    var accessoryImageSystemName: String? = "chevron.forward"
    
    var body: some View {
        HStack(spacing: 0) {
            switch imageAsset {
            case .systemImage(let name):
                Image(systemName: name)
                    .font(.body)
                    .foregroundColor(.accentColor)
//                    .imageScale(.large)
                    .frame(width: imageWidth, height: imageWidth)
            case .custom(let name):
                Image(name)
                    .resizable()
                    .foregroundColor(.accentColor)
                    .frame(width: imageWidth, height: imageWidth)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                if let subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading)
            
            Spacer()
            
            if let accessoryImageSystemName {
                Image(systemName: accessoryImageSystemName)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.tertiaryLabel)
                    .padding(.leading, 2)
            }
        }
        .frame(minHeight: subtitle != nil ? 40 : nil)
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
