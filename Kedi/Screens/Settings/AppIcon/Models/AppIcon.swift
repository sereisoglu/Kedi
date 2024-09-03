//
//  AppIcon.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/13/24.
//

import UIKit

enum AppIcon: String, CaseIterable {
    
    case `default` = "AppIcon"
    case defaultWhite = "AppIcon-White"
    case defaultGray = "AppIcon-Gray"
    case defaultWhiteBlack = "AppIcon-White-Black"
    case defaultSixColors = "AppIcon-Six-Colors"
    case defaultSixColorsWhite = "AppIcon-Six-Colors-White"
    case screaming = "AppIcon-Screaming"
    case screamingWhite = "AppIcon-Screaming-White"
    case screamingGray = "AppIcon-Screaming-Gray"
    case screamingWhiteBlack = "AppIcon-Screaming-White-Black"
    case screamingSixColors = "AppIcon-Screaming-Six-Colors"
    case screamingSixColorsWhite = "AppIcon-Screaming-Six-Colors-White"
    
    var identifier: String? {
        self == .default ? nil : self.rawValue
    }
    
    var preview: String {
        "AppIcon-Previews/\(rawValue)"
    }
    
    var name: String {
        switch self {
        case .default: "Default"
        case .defaultWhite: "White"
        case .defaultGray: "Gray"
        case .defaultWhiteBlack: "White / Black"
        case .defaultSixColors: "Six Colors"
        case .defaultSixColorsWhite: "Six Colors White"
        case .screaming: "Default"
        case .screamingWhite: "White"
        case .screamingGray: "Gray"
        case .screamingWhiteBlack: "White / Black"
        case .screamingSixColors: "Six Colors"
        case .screamingSixColorsWhite: "Six Colors White"
        }
    }
    
    var section: String {
        switch self {
        case .default,
                .defaultWhite,
                .defaultGray,
                .defaultWhiteBlack,
                .defaultSixColors,
                .defaultSixColorsWhite:
            return "Money Mouth"
        case .screaming,
                .screamingWhite,
                .screamingGray,
                .screamingWhiteBlack,
                .screamingSixColors,
                .screamingSixColorsWhite:
            return "Screaming"
        }
    }
    
    static let sections = ["Money Mouth", "Screaming"]
}
