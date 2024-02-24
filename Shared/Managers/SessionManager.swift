//
//  SessionManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/21/24.
//

import Foundation

final class SessionManager {
    
    private let cookieStorage = HTTPCookieStorage.shared
    private let groupCookieStorage = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: "group.com.sereisoglu.kedi")
    
    static let shared = SessionManager()
    
    private init() {}
    
    func start() {
        setGroupRevenueCatCookie()
        
        print("\n", "COOKIES:", "\n", cookieStorage.cookies ?? [])
        print("\n", "GROUP COOKIES:", "\n", groupCookieStorage.cookies ?? [])
    }
    
    func startWidgetExtension() {
        setRevenueCatCookie()
        
        print("\n", "COOKIES:", "\n", cookieStorage.cookies ?? [])
        print("\n", "GROUP COOKIES:", "\n", groupCookieStorage.cookies ?? [])
    }
    
    func getRevenueCatCookie() -> HTTPCookie? {
        guard let url = URL(string: "https://api.revenuecat.com") else {
            return nil
        }
        
        return cookieStorage.cookies(for: url)?.first
    }
    
    private func setRevenueCatCookie() {
        guard let cookie = getGroupRevenueCatCookie() else {
            return
        }
        
        cookieStorage.setCookie(cookie)
    }
    
    private func getGroupRevenueCatCookie() -> HTTPCookie? {
        guard let url = URL(string: "https://api.revenuecat.com") else {
            return nil
        }
        
        return groupCookieStorage.cookies(for: url)?.first
    }
    
    private func setGroupRevenueCatCookie() {
        guard let cookie = getRevenueCatCookie() else {
            return
        }
        
        groupCookieStorage.setCookie(cookie)
    }
}
