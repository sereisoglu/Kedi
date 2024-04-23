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
            makeBody()
        }
        .navigationTitle("Notifications")
        .navigationDestination(for: NotificationItem.self) { notification in
            TransactionDetailView(viewModel: .init(appId: notification.appId, subscriberId: notification.subscriberId))
        }
        .navigationDestination(for: String.self) { screen in
            switch screen {
            case "webhooks":
                WebhooksView()
                    .environmentObject(pushNotificationsManager)
            case "allWebhooks":
                AllWebhooksView()
            case "webhooksManualSetup":
                WebhooksManualSetupView()
                    .environmentObject(pushNotificationsManager)
            default:
                Text("Unknown destination!")
            }
        }
        .overlay(content: makeStateView)
        .scrollContentBackground(viewModel.state == .data ? .automatic : .hidden)
        .background(Color.systemGroupedBackground)
        .redacted(reason: viewModel.state == .loading ? .placeholder : [])
        .disabled(viewModel.state == .loading)
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
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
                .listSectionSpacing(.compact)
            }
            
            if viewModel.state == .data {
                Text("You can view the last 30 events for each project since the date you added the webhook.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .listRowInsets(.zero)
                    .listRowBackground(Color.clear)
                    .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func makeStateView() -> some View {
        switch viewModel.state {
        case .empty:
            ContentUnavailableView {
                Label("Empty", systemImage: "xmark.circle")
            } description: {
                Text("No notifications")
            } actions: {
                NavigationLink("Setup Webhooks", value: "webhooks")
            }
            
        case .error(let error):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(error.displayableLocalizedDescription)
            )
            
        case .loading,
                .data:
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
