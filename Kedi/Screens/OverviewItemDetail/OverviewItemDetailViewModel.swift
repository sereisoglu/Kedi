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
    
    let action: Action
    @Published var configSelection: OverviewItemConfig
    
    init(config: OverviewItemConfig?) {
        if let config {
            action = .edit(config: config)
            configSelection = config
        } else {
            action = .add
            configSelection = .init(type: .revenue, timePeriod: .last30Days)
        }
    }
}
