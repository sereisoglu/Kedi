//
//  Image+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/28/24.
//

import SwiftUI

extension Image {
    
    init?(data: Data) {
        #if canImport(UIKit)
        if let image = UIImage(data: data) {
            self = Image(uiImage: image)
            return
        }
        #elseif canImport(AppKit)
        if let image = NSImage(data: data) {
            self = Image(nsImage: image)
            return
        }
        #endif
        return nil
    }
}
