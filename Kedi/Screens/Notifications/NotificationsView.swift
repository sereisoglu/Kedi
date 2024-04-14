//
//  NotificationsView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/24/24.
//

import SwiftUI

struct NotificationsView: View {
    
    @StateObject private var viewModel = NotificationsViewModel()
    @EnvironmentObject var pushNotificationsManager: PushNotificationsManager
    
    var body: some View {
        List {
            if !pushNotificationsManager.isNotificationsAllowed {
                Section {
                    Toggle(
                        "Notifications",
                        systemImage: "bell.badge",
                        isOn: $pushNotificationsManager.isNotificationsAllowed
                    )
                } footer: {
                    Text("You need to allow notifications for webhook integration.")
                }
            } else {
                ForEach(viewModel.notificationSections) { section in
                    Section {
                        ForEach(section.notifications) { notification in
                            NavigationLink(value: notification) {
                                NotificationItemView(notification: notification)
                            }
                        }
                    } header: {
                        Text(section.date.format(to: .EEE_MMM_d_yyyy))
                    }
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationDestination(for: NotificationItem.self) { notification in
            TransactionDetailView(viewModel: .init(appId: notification.appId, subscriberId: notification.subscriberId))
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
