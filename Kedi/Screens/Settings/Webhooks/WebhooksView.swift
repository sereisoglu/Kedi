//
//  WebhooksView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/31/24.
//

import SwiftUI

struct WebhooksView: View {
    
    @StateObject private var viewModel = WebhooksViewModel()
    @EnvironmentObject var pushNotificationsManager: PushNotificationsManager
    
    @State private var showingResetWebhooksAlert = false
    @State private var isIdHidden = true
    
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
                Section {
                    ForEach($viewModel.webhooks) { $webhook in
                        WebhookItemView(webhook: $webhook)
                            .environmentObject(viewModel)
                    }
                } header: {
                    Text("Projects")
                }
                
                Section {
                    NavigationLink("All Webhooks", value: "allWebhooks")
                }
                
                Section {
                    NavigationLink("Webhooks Manual Setup", value: "webhooksManualSetup")
                }
                
                Section {
                    Button {
                        showingResetWebhooksAlert = true
                    } label: {
                        Text("Reset Webhooks")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    .confirmationDialog(
                        "Reset Webhooks",
                        isPresented: $showingResetWebhooksAlert
                    ) {
                        Button("Cancel", role: .cancel) {}
                        Button("Reset", role: .destructive) {
                            Task {
                                await viewModel.resetWebhooks()
                            }
                        }
                    } message: {
                        Text("Are you sure you want to reset webhooks?")
                    }
                }
                
                Section {
                    VStack(spacing: 5) {
                        Text("ID is unique for this device. Please do not share it with anyone!")
                        
                        Text(viewModel.id)
                            .fontDesign(.monospaced)
                            .redacted(reason: isIdHidden ? .placeholder : [])
                            .onTapGesture {
                                isIdHidden.toggle()
                            }
                            .onLongPressGesture {
                                UIPasteboard.general.setValue(viewModel.id, forPasteboardType: "public.plain-text")
                            }
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
                .listSectionSpacing(.compact)
            }
        }
        .navigationTitle("Webhooks")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    BrowserUtility.openUrlInApp(urlString: "https://www.revenuecat.com/docs/integrations/webhooks")
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .webhooksChange)) { _ in
            Task {
                await viewModel.refresh()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .errorAlert(error: $viewModel.errorAlert)
    }
}

#Preview {
    WebhooksView()
}
