//
//  PaydayViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/26/24.
//

import Foundation

final class PaydayViewModel: ObservableObject {
    
    let upcomingPayday: AppStorePayday?
    let paydays: [Int: [AppStorePayday]]
    
    init() {
        upcomingPayday = AppStorePayday.upcomingPayday
        paydays = .init(grouping: AppStorePayday.paydays, by: { $0.fiscalYear })
    }
}
