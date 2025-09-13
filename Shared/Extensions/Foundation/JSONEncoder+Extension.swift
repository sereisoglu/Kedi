//
//  JSONEncoder+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 9/14/25.
//

import Foundation

extension JSONEncoder {
    
    static let `default`: JSONEncoder = {
        let decoder = JSONEncoder()
        return decoder
    }()
}
