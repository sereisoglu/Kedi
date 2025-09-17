//
//  ButtonRole+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 9/18/25.
//

import SwiftUI

extension ButtonRole {
    
    static var safeConfirm: ButtonRole? {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            .confirm
        } else {
            nil
        }
    }
    
    static var safeClose: ButtonRole? {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            .close
        } else {
            .cancel // nil
        }
    }
}
