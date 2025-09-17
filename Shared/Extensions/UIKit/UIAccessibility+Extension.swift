//
//  UIAccessibility+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 9/18/25.
//

import SwiftUI

// https://www.hackingwithswift.com/books/ios-swiftui/supporting-specific-accessibility-needs-with-swiftui

func withOptionalAnimation<Result>(
    _ animation: Animation? = .default,
    _ body: () throws -> Result
) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        try body()
    } else {
        try withAnimation(animation, body)
    }
}
