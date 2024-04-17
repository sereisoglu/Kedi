//
//  AllWebhookItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/10/24.
//

import Foundation

struct AllWebhookItem: Identifiable, Hashable {
    
    var id: String { project.id }
    var project: Project
    var webhooks: [Webhook]
}

struct Webhook: Identifiable, Hashable {
    
    var id: String
    var name: String
    var url: String
    
    var deviceId: String {
        name.components(separatedBy: " / ")[safe: 2] ?? ""
    }
}
