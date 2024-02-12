//
//  SettingsAccountItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/11/24.
//

import SwiftUI

struct SettingsAccountItemView: View {
    
    let key: String
    let value: String
    
    var body: some View {
        HStack {
            Text(key)
                .foregroundColor(.secondary)
                .font(.callout)
            
            Spacer()
            
            Text(value)
                .font(.callout)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    SettingsAccountItemView(key: "", value: "")
}
