//
//  JSONDecoder+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 9/13/25.
//

import Foundation

extension JSONDecoder {
    
    static let `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
}
