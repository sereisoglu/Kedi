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
    
    @Published private(set) var state: GeneralState = .loading
    
    @Published private(set) var me: RCMeResponse?
    
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
            
            let imageDatas = await fetchImages(urlStrings: rcProjects?.compactMap(\.iconUrl) ?? [])
            
            let projects: [Project] = rcProjects?.compactMap { project in
                guard let projectId = project.id,
                      let name = project.name,
                      let app = me?.apps?.first(where: { $0.name == name }),
                      let appId = app.id else {
                    return nil
                }
                return .init(
                    iconUrl: project.iconUrl,
                    icon: imageDatas[project.iconUrl ?? ""],
                    projectId: projectId,
                    appId: appId,
                    name: name
                )
            } ?? []
            
            meManager.set(me: me, projects: projects)
            
            self.me = me
            
            state = me != nil ? .data : .error(RCError.internal(.nilResponse))
        } catch {
            state = .error(error)
        }
    }
    
    private func fetchImages(urlStrings: [String]) async -> [String: Data] {
        await withTaskGroup(of: (String, Data?).self) { group in
            urlStrings.forEach { urlString in
                group.addTask { [weak self] in
                    (urlString, try? await self?.apiService.download(urlString: urlString))
                }
            }
            
            var imageDatas = [String: Data]()
            for await (urlString, data) in group {
                imageDatas[urlString] = data
            }
            return imageDatas
        }
    }
    
    func refresh() async {
        await fetchMe()
    }
}

// MARK: - Actions

extension SettingsViewModel {
    
    @MainActor
    func handleSignOutButton() {
        meManager.signOut()
    }
}
