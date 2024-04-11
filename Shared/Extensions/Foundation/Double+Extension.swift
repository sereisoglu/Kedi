//
//  Double+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/16/24.
//

import Foundation

extension Double {
    
    var toInt: Int {
        Int(self)
    }
    
    func floorToNearest(_ value: Self) -> Self {
        floor(self / value) * value
    }
    
    func ceilToNearest(_ value: Self) -> Self {
        ceil(self / value) * value
    }
}
