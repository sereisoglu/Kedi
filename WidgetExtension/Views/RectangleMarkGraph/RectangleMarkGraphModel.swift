//
//  RectangleMarkGraphModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import Foundation

typealias RectangleMarkGraphModel = [Date: RectangleMarkGraphValue]

struct RectangleMarkGraphValue {
    
    var date: Date
    var value: Double
}
