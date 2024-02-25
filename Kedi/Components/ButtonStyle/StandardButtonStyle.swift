//
//  StandardButtonStyle.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import SwiftUI

struct StandardButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(1)
    }
}
