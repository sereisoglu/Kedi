//
//  AppIcon.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/13/24.
//

import UIKit

enum AppIcon: String, CaseIterable {
    
    case `default` = "AppIcon"
    case moneyMouthWhiteBlack = "money-mouth-white-black"
    case moneyMouthBlackWhite = "money-mouth-black-white"
    case moneyMouthWhiteBrand = "money-mouth-white-brand"
    case moneyMouthBlackBrand = "money-mouth-black-brand"
    case screamingDefault = "screaming-default"
    case screamingWhiteBlack = "screaming-white-black"
    case screamingBlackWhite = "screaming-black-white"
    case screamingWhiteBrand = "screaming-white-brand"
    case screamingBlackBrand = "screaming-black-brand"
    
    var identifier: String? {
        self == .default ? nil : self.rawValue
    }
    
    var uiImage: UIImage {
        UIImage(named: rawValue) ?? UIImage()
    }
    
    var name: String {
        switch self {
        case .default: "Default"
        case .moneyMouthWhiteBlack: "White / Black"
        case .moneyMouthBlackWhite: "Black / White"
        case .moneyMouthWhiteBrand: "White / Brand"
        case .moneyMouthBlackBrand: "Black / Brand"
        case .screamingDefault: "Default"
        case .screamingWhiteBlack: "White / Black"
        case .screamingBlackWhite: "Black / White"
        case .screamingWhiteBrand: "White / Brand"
        case .screamingBlackBrand: "Black / Brand"
        }
    }
    
    var section: String {
        switch self {
        case .`default`,
                .moneyMouthWhiteBlack,
                .moneyMouthBlackWhite,
                .moneyMouthWhiteBrand,
                .moneyMouthBlackBrand:
            return "Money Mouth"
        case .screamingDefault,
                .screamingWhiteBlack,
                .screamingBlackWhite,
                .screamingWhiteBrand,
                .screamingBlackBrand:
            return "Screaming"
        }
    }
    
    static let sections = ["Money Mouth", "Screaming"]
}
