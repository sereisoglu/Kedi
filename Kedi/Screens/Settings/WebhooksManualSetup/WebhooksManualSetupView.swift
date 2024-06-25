//
//  WebhooksManualSetupView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/4/24.
//

import SwiftUI

struct WebhooksManualSetupView: View {
    
    @EnvironmentObject var pushNotificationsManager: PushNotificationsManager
    @EnvironmentObject var meManager: MeManager
    
    @State private var isWebhookUrlCopied = false
    
    private var webhookUrl: String {
        "https://api.kediapp.com/webhook?id=\(meManager.id ?? "")"
    }
    
    var body: some View {
        List {
            Section {
                Toggle(
                    "Notifications",
                    systemImage: "bell.badge",
                    isOn: $pushNotificationsManager.isAllowed
                )
            } header: {
                Text("Step 1 – Enable Notifications")
            }  footer: {
                Text("You need to allow notifications for webhook integration.")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Button {
                        isWebhookUrlCopied = true
                        UIPasteboard.general.setValue(webhookUrl, forPasteboardType: "public.plain-text")
                    } label: {
                        Label("Copy Webhook URL", systemImage: isWebhookUrlCopied ? "checkmark" : "doc.on.doc")
                    }
                    
                    Text(verbatim: webhookUrl)
                        .font(.footnote)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Step 2 – Copy Webhook URL")
            } footer : {
                Text("ID is unique for this device. Please do not share it with anyone!")
            }
            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                0
            }
            
            Section {
                Link(destination: URL(string: "https://app.revenuecat.com")!) {
                    Label("Go to RevenueCat website", systemImage: "globe")
                }
            } header: {
                Text("Step 3 – Set Webhook URL")
            } footer: {
                Text(#"""
                • Select the project for which you want to integrate webhook.
                • Add a new webhook integration.
                • Paste the webhook url.
                • Click on "Send test Webhook". If the test notification comes to your device, it means that you have successfully integrated the webhook.
                
                Remember, you need to follow these steps for each project for which you want to receive notifications.
                """#)
            }
        }
        .navigationTitle("Webhooks Manual Setup")
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
    }
}

#Preview {
    WebhooksManualSetupView()
}
