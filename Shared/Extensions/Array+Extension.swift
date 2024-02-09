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

extension Array where Element == Double {
    
    func median() -> Double? {
        guard count > 0 else { return
            nil
        }
        
        let sortedArray = sorted()
        if count % 2 != 0 {
            return sortedArray[count / 2]
        } else {
            return (sortedArray[count / 2] + sortedArray[(count / 2) - 1]) / 2.0
        }
    }
}
