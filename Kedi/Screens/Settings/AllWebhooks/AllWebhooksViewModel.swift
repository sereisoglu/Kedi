//
//  AllWebhooksViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 4/10/24.
//

import Foundation

final class AllWebhooksViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    private let meManager = MeManager.shared
    
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var items = [AllWebhookItem]()
    @Published var errorAlert: Error?
    
    private var projects: [Project] {
        meManager.projects ?? []
    }
    
    init() {
        Task {
            await fetchWebhooks()
        }
    }
    
    @MainActor
    private func fetchWebhooks() async {
        let allWebhooks = await withTaskGroup(of: (String, [Webhook]?).self) { group in
            projects.forEach { project in
                group.addTask { [weak self] in
                    (project.id, await self?.fetchWebhook(projectId: project.id))
                }
            }
            
            var allWebhooks = [String: [Webhook]]()
            for await (projectId, webhooks) in group {
                allWebhooks[projectId] = webhooks
            }
            return allWebhooks
        }
        
        items = projects.compactMap { project in
            guard let webhooks = allWebhooks[project.id] else {
                return nil
            }
            return .init(project: project, webhooks: webhooks)
        }
        
        state = items.isEmpty ? .empty : .data
    }
    
    private func fetchWebhook(projectId: String) async -> [Webhook]? {
        do {
            let webhooks = try await apiService.request(
                type: RCWebhooksResponse.self,
                endpoint: .webhooks(projectId: projectId)
            )
            return webhooks?.compactMap { webhook in
                guard let id = webhook.id,
                      let name = webhook.name,
                      let url = webhook.url else {
                    return nil
                }
                return .init(id: id, name: name, url: url)
            }
        } catch {
            return nil
        }
    }
    
    private func deleteWebhook(projectId: String, webhookId: String) async -> Error? {
        do {
            try await apiService.request(
                type: RCDeleteWebhookResponse.self,
                endpoint: .deleteWebhook(projectId: projectId, webhookId: webhookId)
            )
            return nil
        } catch {
            return error
        }
    }
    
    @MainActor
    func delete(itemId: String, index: Int) {
        Task {
            guard let itemIndex = items.firstIndex(where: { $0.id == itemId }),
                  let item = items[safe: itemIndex],
                  let webhookId = item.webhooks[safe: index]?.id else {
                return
            }
            
            let error = await deleteWebhook(projectId: item.project.id, webhookId: webhookId)
            
            if error == nil {
                items[itemIndex].webhooks.remove(at: index)
                NotificationCenter.default.post(name: .webhooksChange, object: nil)
            } else {
                errorAlert = error
            }
        }
    }
    
    func refresh() async {
        await fetchWebhooks()
    }
}
