//
//  TransactionDetailInfoItem.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import Foundation

struct TransactionDetailInfoItem: Identifiable, Hashable {
    
    let id = UUID()
    var key: String
    var value: String
    var copyable: Bool = false
}
