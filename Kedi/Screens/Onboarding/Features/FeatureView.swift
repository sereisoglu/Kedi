//
//  FeatureView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/23/24.
//

import SwiftUI

struct FeatureView: View {
    
    let feature: Feature
    
    var body: some View {
        VStack(spacing: 10) {
            Image(feature.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack(spacing: 4) {
                HStack(spacing: 5) {
                    Image(systemName: feature.titleIcon)
                        .foregroundStyle(Color.accentColor)
                    
                    Text(feature.title)
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                Text(feature.description)
                    .font(.body)
                    .lineLimit(3, reservesSpace: true)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            .frame(maxWidth: 450)
        }
    }
}

#Preview {
    FeatureView(feature: .init(
        image: .Images.onboarding2,
        titleIcon: "bell",
        title: "Notifications",
        description: "Add a webhook with just one tap to receive notifications of transactions in your projects"
    ))
}
