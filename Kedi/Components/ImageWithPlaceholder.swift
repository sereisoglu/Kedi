//
//  ImageWithPlaceholder.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/28/24.
//

import SwiftUI

struct ImageWithPlaceholder<Content, Placeholder>: View where Content: View, Placeholder: View {

    private let data: Data?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    init(
        data: Data?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.data = data
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        if let data,
           let image = Image(data: data) {
            content(image)
        } else {
            placeholder()
        }
    }
}
