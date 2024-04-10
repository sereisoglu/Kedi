//
//  WebhooksViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/31/24.
//

import Foundation

final class WebhooksViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    private let meManager = MeManager.shared
    
    @Published var webhooks = [WebhookItem]()
    @Published var errorAlert: Error?
    
    var projects: [Project] {
        meManager.projects ?? []
    }
    
    var id: String {
        meManager.id ?? ""
    }
    
    init() {
        webhooks = projects.map { .init(state: .loading, project: $0) }
        
        Task {
            await fetchWebhooks()
        }
    }
    
    @MainActor
    private func fetchWebhooks() async {
        let states = await withTaskGroup(of: (String, WebhookState?).self) { group in
            projects.forEach { project in
                group.addTask { [weak self] in
                    (project.id, await self?.fetchWebhook(projectId: project.id))
                }
            }
            
            var states = [String: WebhookState]()
            for await (projectId, state) in group {
                states[projectId] = state
            }
            return states
        }
        
        webhooks = webhooks.compactMap { webhook in
            guard let state = states[webhook.project.id] else {
                return nil
            }
            return .init(state: state, project: webhook.project)
        }
    }
    
    private func fetchWebhook(projectId: String) async -> WebhookState {
        do {
            let data = try await apiService.request(
                type: RCWebhooksResponse.self,
                endpoint: .webhooks(projectId: projectId)
            )
            
            if let webhookId = data?.first(where: { $0.url?.lowercased().hasPrefix("https://api.kediapp.com/webhook") ?? false })?.id {
                return .active(webhookId: webhookId)
            } else {
                return .inactive
            }
        } catch {
            return .error(error)
        }
    }
    
    @MainActor
    func toggleWebhook(projectId: String) {
        guard let index = webhooks.firstIndex(where: { $0.project.id == projectId }),
              let webhook = webhooks[safe: index] else {
            return
        }
        
        switch webhook.state {
        case .active(let webhookId):
            Task {
                webhooks[index].state = .loading
                
                do {
                    try await apiService.request(
                        type: RCDeleteWebhookResponse.self,
                        endpoint: .deleteWebhook(projectId: projectId, webhookId: webhookId)
                    )
                    
                    webhooks[index].state = .inactive
                } catch {
                    webhooks[index].state = .error(error)
                }
            }
            
        case .inactive:
            Task {
                webhooks[index].state = .loading
                
                do {
                    let data = try await apiService.request(
                        type: RCCreateWebhookResponse.self,
                        endpoint: .createWebhook(
                            projectId: projectId,
                            request: .init(
                                name: "Kedi",
                                url: "https://api.kediapp.com/webhook?id=\(id)"
                            )
                        )
                    )
                    
                    webhooks[index].state = .active(webhookId: data?.id ?? "")
                } catch {
                    webhooks[index].state = .error(error)
                }
            }
            
        case .loading,
                .error:
            return
        }
    }
    
    @MainActor
    func sendTestNotification(projectId: String, webhookId: String) async {
        do {
            try await apiService.request(
                type: RCTestWebhookResponse.self,
                endpoint: .testWebhook(projectId: projectId, webhookId: webhookId)
            )
        } catch {
            errorAlert = error
        }
    }
    
    func resetWebhooks() {
        meManager.generateId()
    }
}
