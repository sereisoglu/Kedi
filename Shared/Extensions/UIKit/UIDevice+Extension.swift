//
//  UIDevice+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/10/24.
//

import UIKit

// https://stackoverflow.com/a/30075200/9212388
extension UIDevice {
    
    var modelIdentifier: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters) ?? ""
    }
}
