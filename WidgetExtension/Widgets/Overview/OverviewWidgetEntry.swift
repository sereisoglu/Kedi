//
//  OverviewWidgetEntry.swift
//  WidgetExtension
//
//  Created by Saffet Emin Reisoğlu on 2/10/24.
//

import SwiftUI
import WidgetKit

struct OverviewWidgetEntry: TimelineEntry {
    
    var items3: [OverviewItem] {
        let types: [OverviewItemType] = [.mrr, .subsciptions, .revenue]
        return items.filter { types.contains($0.type) }
    }
    
    let date: Date
    let items: [OverviewItem]
    var error: RCError?
}

struct OverviewItem: Hashable, Codable {
    
    var type: OverviewItemType
    var value: String
}

enum OverviewItemType: String, CaseIterable, Codable {
    
    case mrr
    case subsciptions
    case trials
    case revenue
    case users
    case installs
    
    var icon: String {
        switch self {
        case .mrr: "dollarsign.arrow.circlepath"
        case .subsciptions: "repeat"
        case .trials: "clock"
        case .revenue: "dollarsign.circle"
        case .users: "person.2"
        case .installs: "iphone"
        }
    }
    
    var name: String {
        switch self {
        case .mrr: "MRR"
        case .subsciptions: "Subsciptions"
        case .trials: "Trials"
        case .revenue: "Revenue"
        case .users: "Users"
        case .installs: "Installs"
        }
    }
    
    var color: Color {
        switch self {
        case .mrr: .green
        case .subsciptions: .blue
        case .trials: .orange
        case .revenue: .green
        case .users: .secondary
        case .installs: .secondary
        }
    }
}

extension OverviewWidgetEntry {
    
    static let placeholder: Self = {
        let data = RCOverviewResponse.stub
        
        return .init(
            date: Date(),
            items:  [
                .init(type: .mrr, value: "\(data.mrr?.formatted(.currency(code: "USD")) ?? "")"),
                .init(type: .subsciptions, value: "\(data.activeSubscribersCount?.formatted() ?? "")"),
                .init(type: .trials, value: "\(data.activeTrialsCount?.formatted() ?? "")"),
                .init(type: .revenue, value: "\(data.revenue?.formatted(.currency(code: "USD")) ?? "")"),
                .init(type: .users, value: "\(data.activeUsersCount?.formatted() ?? "")"),
                .init(type: .installs, value: "\(data.installsCount?.formatted() ?? "")")
            ]
        )
    }()
}
