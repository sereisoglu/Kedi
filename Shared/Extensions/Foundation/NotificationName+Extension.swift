//
//  NotificationName+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/11/24.
//

import Foundation

extension Notification.Name {
    
    static let purchase = Notification.Name("purchase")
    static let webhooksChange = Notification.Name("webhooksChange")
    static let apiServiceRequestError = Notification.Name("apiServiceRequestError")
}
