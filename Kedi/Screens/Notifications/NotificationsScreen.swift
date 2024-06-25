//
//  NotificationsScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/24/24.
//

import SwiftUI

struct NotificationsScreen: View {
    
    @EnvironmentObject var pushNotificationsManager: PushNotificationsManager
    
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        List {
            makeBody()
        }
        .navigationTitle("Notifications")
        .navigationDestination(for: NotificationItem.self) { notification in
            TransactionDetailScreen(viewModel: .init(appId: notification.appId, subscriberId: notification.subscriberId))
        }
        .navigationDestination(for: String.self) { screen in
            switch screen {
            case "webhooks":
                WebhooksScreen()
            case "allWebhooks":
                AllWebhooksScreen()
            case "webhooksManualSetup":
                WebhooksManualSetupScreen()
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
        if !pushNotificationsManager.isAllowed {
            Section {
                Toggle(
                    "Notifications",
                    systemImage: "bell.badge",
                    isOn: $pushNotificationsManager.isAllowed
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
        if pushNotificationsManager.isAllowed {
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
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsScreen()
    }
}
