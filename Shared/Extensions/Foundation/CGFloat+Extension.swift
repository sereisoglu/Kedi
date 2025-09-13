//
//  CGFloat+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 9/14/25.
//

import Foundation

extension CGFloat {
    
    static let cornerRadiusRow: Self = {
        if #available(iOS 26, *) {
            26 // 52/2
        } else {
            20
        }
    }()
}
