//
//  SettingsViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/3/24.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    private let meManager = MeManager.shared
    private let authManager = AuthManager.shared
    
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var me: RCMeResponse?
    @Published var errorAlert: Error?
    
    var projects: [Project] {
        meManager.projects ?? []
    }
    
    var authTokenExpiresDate: Date? {
        authManager.getAuthTokenExpiresDate()
    }
    
    init() {
        if let me = meManager.me {
            self.me = me
            state = .data
        } else {
            self.me = .stub
            state = .loading
        }
        
        Task {
            await fetchMe()
        }
    }
    
    @MainActor
    private func fetchMe() async {
        do {
            async let meRequest = apiService.request(
                type: RCMeResponse.self,
                endpoint: .me
            )
            
            async let projectsRequest = apiService.request(
                type: RCProjectsResponse.self,
                endpoint: .projects
            )
            
            let (me, rcProjects) = try await (meRequest, projectsRequest)
            
            async let projectDetailRequests = fetchProjectDetails(ids: rcProjects?.compactMap(\.id) ?? [])
            
            async let imageRequests = fetchImages(urlStrings: rcProjects?.compactMap(\.iconUrl) ?? [])
            
            let (rcProjectDetails, icons) = await (projectDetailRequests, imageRequests)
            
            let projects: [Project] = rcProjectDetails.compactMap { projectDetail in
                guard let id = projectDetail.id,
                      let name = projectDetail.name else {
                    return nil
                }
                return .init(
                    id: id,
                    iconUrl: projectDetail.iconUrl,
                    icon: icons[projectDetail.iconUrl ?? ""],
                    name: name,
                    apps: projectDetail.apps?.compactMap { app in
                        guard let id = app.id,
                              let store = app.type else {
                            return nil
                        }
                        return .init(id: id, store: store)
                    },
                    webhookId: self.projects.first(where: { $0.id == id })?.webhookId
                )
            }
            
            meManager.set(me: me)
            meManager.set(projects: projects)
            
            self.me = me
            
            state = me != nil ? .data : .error(RCError.internal(.nilResponse))
        } catch {
            state = .error(error)
        }
    }
    
    private func fetchProjectDetails(ids: [String]) async -> [RCProjectDetailResponse] {
        await withTaskGroup(of: RCProjectDetailResponse?.self) { group in
            ids.forEach { id in
                group.addTask { [weak self] in
                    try? await self?.apiService.request(
                        type: RCProjectDetailResponse.self,
                        endpoint: .projectDetail(id: id)
                    )
                }
            }
            
            var projectDetails = [RCProjectDetailResponse]()
            for await projectDetail in group {
                if let projectDetail {
                    projectDetails.append(projectDetail)
                }
            }
            return projectDetails
        }
    }
    
    private func fetchImages(urlStrings: [String]) async -> [String: Data] {
        await withTaskGroup(of: (String, Data?).self) { group in
            urlStrings.forEach { urlString in
                group.addTask { [weak self] in
                    (urlString, try? await self?.apiService.download(urlString: urlString))
                }
            }
            
            var images = [String: Data]()
            for await (urlString, image) in group {
                images[urlString] = image
            }
            return images
        }
    }
    
    @MainActor
    func signOut() async {
        do {
            try await apiService.request(type: RCLogoutResponse.self, endpoint: .logout)
            meManager.signOut()
        } catch {
            errorAlert = error
        }
    }
    
    func refresh() async {
        await fetchMe()
    }
}
