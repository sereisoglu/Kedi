//
//  DeviceUtility.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/10/24.
//

import UIKit

final class DeviceUtility {
    
    static var id: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static var modelId: String {
        UIDevice.current.modelIdentifier
    }
}
