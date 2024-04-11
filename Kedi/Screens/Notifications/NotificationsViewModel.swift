//
//  NotificationsViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/24/24.
//

import Foundation

final class NotificationsViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    
    @Published private(set) var state: ViewState = .loading
    
    init() {
        Task {
            await fetchEvents()
        }
    }
    
    private func fetchEvents() async {
//        do {
//            let data = try await apiService.request(
//                type: RCLatestEventsResponse.self,
//                endpoint: .latestEvents(projectId: <#T##String#>, webhookId: <#T##String#>)
//            )
//        } catch {
//            
//        }
    }
}
