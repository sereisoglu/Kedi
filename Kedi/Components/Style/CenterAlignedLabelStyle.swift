//
//  CenterAlignedLabelStyle.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/17/24.
//

import SwiftUI

struct CenterAlignedLabelStyle: LabelStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 0) {
            configuration.icon
                .padding(.trailing)
            
            configuration.title
        }
    }
}
