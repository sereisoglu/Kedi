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
    
    @Published private(set) var state: GeneralState = .loading
    
    @Published private(set) var me: RCMeResponse?
    
    var authTokenExpiresDate: Date? {
        meManager.getAuthTokenExpiresDate()
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
            let me = try await apiService.request(
                type: RCMeResponse.self,
                endpoint: .me
            )
            
            if let imageUrlStrings = me?.apps?.compactMap(\.bundleId).map({ "https://www.appatar.io/\($0)/small" }) {
                let images = await fetchImages(urlStrings: imageUrlStrings)
                
                images.forEach { urlString, data in
                    CacheManager.shared.set(key: urlString, data: data, expiry: .never)
                }
            }
            
            if let me {
                meManager.set(me: me)
                state = .data
            } else {
                state = .error(RCError.internal(.nilResponse))
            }
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
                if let data {
                    imageDatas[urlString] = data
                }
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
