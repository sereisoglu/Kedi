//
//  View+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/13/24.
//

import SwiftUI

// https://www.youtube.com/watch?v=H6S5xKgb9k8
extension View {
    
    func getSize(size: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: ViewPreferenceKey.self, value: geo.size)
            }
        )
        .onPreferenceChange(ViewPreferenceKey.self, perform: size)
    }
}

struct ViewPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
