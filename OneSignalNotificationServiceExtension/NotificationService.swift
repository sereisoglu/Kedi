//
//  NotificationService.swift
//  OneSignalNotificationServiceExtension
//
//  Created by Saffet Emin Reisoğlu on 3/22/24.
//

import UserNotifications
import OneSignalExtension

final class NotificationService: UNNotificationServiceExtension {
    
    private let cacheManager = CacheManager.shared
    
    private var receivedRequest: UNNotificationRequest?
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        receivedRequest = request
        self.contentHandler = contentHandler
        bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
        
        if let userInfo = bestAttemptContent?.userInfo,
           let dataString = ((userInfo["custom"] as? [String: Any])?["a"] as? [String: Any])?["event"] as? String,
           let event = try? JSONDecoder().decode(RCEvent.self, from: .init(dataString.utf8)) {
            let projects = cacheManager.getWithDecode(key: "projects", type: [Project].self)
            let project = projects?.first(where: { $0.apps?.contains(where: { $0.id == event.appId }) ?? false })
            
            let notification = EventNotification(data: event, project: project)
            
            bestAttemptContent?.title = notification.title
            bestAttemptContent?.body = notification.body
        }
        
        guard let receivedRequest,
              let bestAttemptContent else {
            return
        }
        
        OneSignalExtension.didReceiveNotificationExtensionRequest(
            receivedRequest,
            with: bestAttemptContent,
            withContentHandler: contentHandler
        )
    }
    
    override func serviceExtensionTimeWillExpire() {
        guard let receivedRequest,
              let contentHandler,
              let bestAttemptContent else {
            return
        }
        
        OneSignalExtension.serviceExtensionTimeWillExpireRequest(
            receivedRequest,
            with: bestAttemptContent
        )
        contentHandler(bestAttemptContent)
    }
}
