//
//  OverviewItemDetailViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/1/24.
//

import Foundation

final class OverviewItemDetailViewModel: ObservableObject {
    
    enum Action {
        
        case add
        case edit(config: OverviewItemConfig)
    }
    
    enum ConfigState {
        
        case ok
        case notAvailable
        case noChange
        
        var disabled: Bool {
            switch self {
            case .ok: false
            case .notAvailable: true
            case .noChange: true
            }
        }
    }
    
    let action: Action
    
    @Published var configSelection: OverviewItemConfig {
        didSet {
            setConfigState()
        }
    }
    
    @Published var configState: ConfigState = .ok
    
    var notAvailableMessage: String {
        if configSelection.type.valueType == .live {
            return "One from \(OverviewItemType.allCases.filter { $0.valueType == .live }.map(\.title).joined(separator: ", ")) can be added."
        } else {
            return "There is another item with the same configuration."
        }
    }
    
    init(config: OverviewItemConfig?) {
        if let config {
            action = .edit(config: config)
            configSelection = config
        } else {
            action = .add
            configSelection = .init(type: .revenue, timePeriod: .last30Days)
        }
        setConfigState()
    }
    
    private func setConfigState() {
        switch action {
        case .add:
            configState = OverviewItemConfig.isAvailable(config: configSelection) ? .ok : .notAvailable
        case .edit(let config):
            if config == configSelection {
                configState = .noChange
            } else {
                configState = OverviewItemConfig.isAvailable(config: configSelection) ? .ok : .notAvailable
            }
        }
    }
}
