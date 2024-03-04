//
//  OverviewDetailViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/5/24.
//

import Foundation

final class OverviewDetailViewModel: ObservableObject {
    
    let item: OverviewItem
    @Published var configSelection: OverviewItemConfig
    
    init(item: OverviewItem) {
        self.item = item
        configSelection = item.config
    }
}
