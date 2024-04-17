//
//  NotificationService.swift
//  OneSignalNotificationServiceExtension
//
//  Created by Saffet Emin Reisoğlu on 3/22/24.
//

import UserNotifications
import Intents
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
        
        if var eventNotification = makeEventNotification(userInfo: bestAttemptContent?.userInfo) {
            let project = getProject(appId: eventNotification.appId)
            eventNotification.projectName = project?.name
            
            if let imageData = project?.icon,
               let content = makeContentForIntent(
                request: request,
                imageData: imageData,
                title: eventNotification.title,
                body: eventNotification.body
               ) {
                bestAttemptContent = content
            } else {
                bestAttemptContent?.title = eventNotification.title
                bestAttemptContent?.body = eventNotification.body
            }
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
    
    private func makeEventNotification(userInfo: [AnyHashable: Any]?) -> EventNotification? {
        guard let userInfo = bestAttemptContent?.userInfo,
              let dataString = ((userInfo["custom"] as? [String: Any])?["a"] as? [String: Any])?["event"] as? String,
              let event = try? JSONDecoder().decode(RCEvent.self, from: .init(dataString.utf8)) else {
            return nil
        }
        return .init(data: event)
    }
    
    private func getProject(appId: String) -> Project? {
        let projects = cacheManager.getWithDecode(key: "projects", type: [Project].self)
        return projects?.first(where: { $0.apps?.contains(where: { $0.id == appId }) ?? false })
    }
    
    private func makeContentForIntent(
        request: UNNotificationRequest,
        imageData: Data,
        title: String,
        body: String
    ) -> UNMutableNotificationContent? {
        let handle = INPersonHandle(value: nil, type: .unknown)
        let avatar = INImage(imageData: imageData)
        let sender = INPerson(
            personHandle: handle,
            nameComponents: nil,
            displayName: title,
            image: avatar,
            contactIdentifier: nil,
            customIdentifier: nil
        )
        let intent = INSendMessageIntent(
            recipients: nil,
            outgoingMessageType: .outgoingMessageText,
            content: nil,
            speakableGroupName: nil,
            conversationIdentifier: nil,
            serviceName: nil,
            sender: sender,
            attachments: nil
        )
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.direction = .incoming
        
        Task {
            try? await interaction.donate()
        }
        
        let content = try? request.content.updating(from: intent)
        let mutableContent = content?.mutableCopy() as? UNMutableNotificationContent
        mutableContent?.body = body
        return mutableContent
    }
}
