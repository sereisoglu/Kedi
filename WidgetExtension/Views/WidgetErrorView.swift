//
//  WidgetErrorView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/12/24.
//

import SwiftUI

struct WidgetErrorView: View {
    
    var error: WidgetError
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: error.icon)
                .font(.title)
                .fontWeight(.semibold)
            
            VStack(spacing: 2) {
                Text(error.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(error.message)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .minimumScaleFactor(0.6)
        }
    }
}

#Preview {
    WidgetErrorView(error: .unauthorized)
}
