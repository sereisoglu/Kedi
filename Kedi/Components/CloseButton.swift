//
//  CloseButton.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/23/24.
//

import SwiftUI
import UIKit

// https://stackoverflow.com/a/73629513/9212388
struct CloseButton: UIViewRepresentable {
    
    final class Coordinator {
        
        var action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func perform() {
            action()
        }
    }
    
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .close)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.addTarget(context.coordinator, action: #selector(Coordinator.perform), for: .primaryActionTriggered)
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        context.coordinator.action = action
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
}
