//
//  Array+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

extension Array {
    
    func keyBy<Key: Hashable>(_ keyFor: (Element) -> Key) -> [Key: Element] {
        var ret = [Key: Element]()
        for item in self {
            ret[keyFor(item)] = item
        }
        return ret
    }
}
