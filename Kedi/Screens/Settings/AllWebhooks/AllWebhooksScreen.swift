//
//  AllWebhooksScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/10/24.
//

import SwiftUI

struct AllWebhooksScreen: View {
    
    @StateObject private var viewModel = AllWebhooksViewModel()
    
    @State private var showingDeleteAlert = false
    @State private var webhookToDelete: (itemId: String, index: Int)?
    
    var body: some View {
        List {
            makeBody()
        }
        .navigationTitle("All Webhooks")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(content: makeStateView)
        .scrollContentBackground(viewModel.state == .data ? .automatic : .hidden)
        .background(Color.systemGroupedBackground)
        .refreshable {
            await viewModel.refresh()
        }
        .errorAlert(error: $viewModel.errorAlert)
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        if viewModel.state == .data {
            ForEach(viewModel.items) { item in
                Section {
                    ForEach(item.webhooks) { webhook in
                        VStack(alignment: .leading) {
                            Text(webhook.name)
                                .font(.body)
                            
                            Text(webhook.url)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            if DeviceUtility.id == webhook.deviceId {
                                Text("🟢 This Device")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 2)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            self.showingDeleteAlert = true
                            self.webhookToDelete = (itemId: item.id, index: index)
                        }
                    }
                } header: {
                    Label {
                        Text(item.project.name)
                    } icon: {
                        ImageWithPlaceholder(data: item.project.icon) { image in
                            image.resizable()
                        } placeholder: {
                            Rectangle()
                                .foregroundStyle(.fill)
                        }
                        .frame(width: 20, height: 20)
                        .clipShape(RoundedRectangle(cornerRadius: 20 * (2 / 9), style: .continuous))
                    }
                }
            }
            .confirmationDialog(
                "Delete Webhook",
                isPresented: $showingDeleteAlert
            ) {
                Button("Cancel", role: .cancel) {
                    webhookToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let webhookToDelete {
                        withAnimation {
                            viewModel.delete(itemId: webhookToDelete.itemId, index: webhookToDelete.index)
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to delete the webhook?")
            }

        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func makeStateView() -> some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
        case .empty:
            ContentUnavailableView(
                "Empty",
                systemImage: "xmark.circle"
            )
            
        case .error(let error):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(error.displayableLocalizedDescription)
            )
            
        case .data:
            EmptyView()
        }
    }
}

#Preview {
    AllWebhooksScreen()
}
