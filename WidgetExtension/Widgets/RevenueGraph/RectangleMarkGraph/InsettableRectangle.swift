//
//  InsettableRectangle.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI

struct InsettableRectangle: Shape {
    
    var inset: CGFloat = 0
    var cornerRadius: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
            in: .init(
                x: rect.minX + inset,
                y: rect.minY + inset,
                width: rect.width - (2 * inset),
                height: rect.height - (2 * inset)
            ),
            cornerSize: .init(width: cornerRadius, height: cornerRadius),
            style: .continuous
        )
        return path
    }
}

#Preview {
    InsettableRectangle()
}
