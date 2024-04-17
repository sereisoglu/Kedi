//
//  WebhookItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/7/24.
//

import SwiftUI

struct WebhookItemView: View {
    
    @EnvironmentObject private var viewModel: WebhooksViewModel
    
    @Binding var webhook: WebhookItem
    
    var body: some View {
        Label {
            switch webhook.state {
            case .active(let webhookId):
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(webhook.project.name)
                        Spacer()
                        Toggle("", isOn: $webhook.isActive)
                            .onChange(of: webhook.isActive) { oldValue, newValue in
                                viewModel.toggleWebhook(projectId: webhook.project.id)
                            }
                    }
                    
                    AsyncButton {
                        await viewModel.sendTestNotification(
                            projectId: webhook.project.id,
                            webhookId: webhookId
                        )
                    } label: {
                        Label("Send Test Notification", systemImage: "paperplane")
                            .font(.subheadline)
                    }
                }
                
            case .inactive:
                HStack {
                    Text(webhook.project.name)
                    Spacer()
                    Toggle("", isOn: $webhook.isActive)
                        .onChange(of: webhook.isActive) { oldValue, newValue in
                            viewModel.toggleWebhook(projectId: webhook.project.id)
                        }
                }
                
            case .loading:
                HStack {
                    Text(webhook.project.name)
                    Spacer()
                    ProgressView()
                }
                
            case .error(let error):
                VStack(alignment: .leading, spacing: 2) {
                    Text(webhook.project.name)
                    
                    Label(error.localizedDescription, systemImage: "exclamationmark.triangle")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
            }
        } icon: {
            ImageWithPlaceholder(data: webhook.project.icon) { image in
                image.resizable()
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.fill)
            }
            .frame(width: 30, height: 30)
            .clipShape(RoundedRectangle(cornerRadius: 30 * (2 / 9), style: .continuous))
        }
    }
}

#Preview {
    WebhookItemView(webhook: .constant(.init(state: .inactive, project: .init(id: "proj001", name: "Kedi"))))
        .environmentObject(WebhooksViewModel())
}
