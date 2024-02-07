//
//  TransactionDetailViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import Foundation

final class TransactionDetailViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    
    let appId: String
    let subscriberId: String
    
    @Published var navigationTitle: String = ""
    
    @Published var detailItems: [TransactionDetailInfoItem]?
    @Published var entitlementItems: [TransactionDetailEntitlementItem]?
    @Published var attributeItems: [TransactionDetailInfoItem]?
    @Published var historyItems: [TransactionDetailHistoryItem]?
    
    init(appId: String, subscriberId: String) {
        self.appId = appId
        self.subscriberId = subscriberId
        
        Task {
            await fetchDetail()
        }
    }
    
    private func fetchDetail() async {
        do {
            let data = try await apiService.request(
                type: RCTransactionDetailModel.self,
                endpoint: .transactionDetail(appId: appId, subscriberId: subscriberId)
            )
            
            await set(data: data)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func set(data: RCTransactionDetailModel?) {
        guard let data else {
            return
        }
        
        navigationTitle = data.subscriberAttributes?.first(where: { $0.key == "$displayName" })?.value ?? subscriberId
        
        detailItems = [
            .init(
                key: "Id",
                value: subscriberId,
                copyable: true
            ),
            .init(
                key: "Total Spend",
                value: data.dollarsSpent?.formatted(.currency(code: "USD")) ?? "n/a"
            ),
            .init(
                key: "Last Seen",
                value: data.lastSeen?.relativeDate(from: .iso8601WithoutMilliseconds, to: .full) ?? "n/a"
            ),
            .init(
                key: "Created",
                value: data.createdAt?.relativeDate(from: .iso8601WithoutMilliseconds, to: .full) ?? "n/a"
            ),
            .init(
                key: "Country",
                value: "\(data.lastSeenCountry?.countryFlagAndName ?? "n/a") (\(data.lastSeenLocale ?? "n/a"))"
            ),
            .init(
                key: "App",
                value: "\(data.app?.name ?? "n/a") (\(data.lastSeenAppVersion ?? "n/a"))"
            ),
            .init(
                key: "Platform",
                value: "\(data.lastSeenPlatform ?? "n/a") (\(data.lastSeenPlatformVersion ?? "n/a"))"
            ),
            .init(
                key: "SDK Version",
                value: data.lastSeenSDKVersion ?? "n/a"
            )
        ]
        
        entitlementItems = data.subscriptionStatuses?.map { .init(data: $0) }
        
        attributeItems = data.subscriberAttributes?.map { .init(
            key: $0.key ?? "n/a",
            value: $0.value ?? "n/a",
            copyable: true
        ) } ?? []
        
        historyItems = data.history?.reversed().map { .init(data: $0) }
    }
}
