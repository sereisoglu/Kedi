//
//  WebhookItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/7/24.
//

import Foundation

struct WebhookItem: Identifiable, Hashable {
    
    var id: String { project.id }
    var state: WebhookState
    var project: Project
    var isActive: Bool = false
    
    init(state: WebhookState, project: Project) {
        self.state = state
        self.project = project
        self.isActive = state.isActive
    }
}

enum WebhookState: Equatable, Hashable {
    
    case active(webhookId: String)
    case inactive
    case loading
    case error(Error)
    
    var isActive: Bool {
        if case .active = self {
            return true
        }
        return false
    }
    
    static func == (lhs: WebhookState, rhs: WebhookState) -> Bool {
        switch (lhs, rhs) {
        case (.active, .active),
            (.inactive, .inactive),
            (.loading, .loading),
            (.error, .error):
            return true
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
