//
//  Text+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/18/24.
//

import SwiftUI

extension Text {
    
    init(imageSystemName: String) {
        self.init("\(Image(systemName: imageSystemName))")
    }
}
