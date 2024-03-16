//
//  Int+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/16/24.
//

import Foundation

// https://stackoverflow.com/a/63538016/9212388
extension FixedWidthInteger {
    
    var size: Self {
        Self("1" + repeatElement("0", count: String(magnitude).count - 1)) ?? 0
    }
}
