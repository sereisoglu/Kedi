//
//  Collection+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

// https://stackoverflow.com/a/30593673/9212388
extension Collection {
    
    subscript(safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}
