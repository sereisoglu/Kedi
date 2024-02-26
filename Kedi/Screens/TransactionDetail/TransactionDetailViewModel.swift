//
//  TransactionDetailViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import Foundation

final class TransactionDetailViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    
    @Published private(set) var state: GeneralState = .loading
    
    @Published private(set) var navigationTitle: String = ""
    @Published private(set) var detailItems: [TransactionDetailInfoItem]?
    @Published private(set) var entitlementItems: [TransactionDetailEntitlementItem]?
    @Published private(set) var attributeItems: [TransactionDetailInfoItem]?
    @Published private(set) var historyItems: [TransactionDetailHistoryItem]?
    
    let appId: String
    let subscriberId: String
    
    init(appId: String, subscriberId: String) {
        self.appId = appId
        self.subscriberId = subscriberId
        
        set(detailData: .stub, activityData: nil)
        navigationTitle = ""
        
        Task {
            await fetchDetail()
        }
    }
    
    @MainActor
    private func fetchDetail() async {
        do {
            let detailData = try await apiService.request(
                type: RCTransactionDetailResponse.self,
                endpoint: .transactionDetail(appId: appId, subscriberId: subscriberId)
            )
            
            let activityData = try await apiService.request(
                type: RCTransactionDetailActivityResponse.self,
                endpoint: .transactionDetailActivity(appId: appId, subscriberId: subscriberId)
            )
            
            set(detailData: detailData, activityData: activityData)
            
            state = .data
        } catch {
            state = .error(error)
        }
    }
    
    private func set(
        detailData: RCTransactionDetailResponse?,
        activityData: RCTransactionDetailActivityResponse?
    ) {
        guard let detailData else {
            return
        }
        
        navigationTitle = detailData.subscriberAttributes?.first(where: { $0.key == "$displayName" })?.value ?? subscriberId
        
        detailItems = [
            .init(
                key: "Id",
                value: subscriberId,
                copyable: true
            ),
            .init(
                key: "Total Spend",
                value: detailData.dollarsSpent?.formatted(.currency(code: "USD")) ?? "n/a"
            ),
            .init(
                key: "Last Seen",
                value: detailData.lastSeen?.relativeDate(from: .iso8601WithoutMilliseconds) ?? "n/a"
            ),
            .init(
                key: "Created",
                value: detailData.createdAt?.relativeDate(from: .iso8601WithoutMilliseconds) ?? "n/a"
            ),
            .init(
                key: "Country",
                value: "\(detailData.lastSeenCountry?.countryFlagAndName ?? "n/a") (\(detailData.lastSeenLocale ?? "n/a"))"
            ),
            .init(
                key: "App",
                value: "\(detailData.app?.name ?? "n/a") (\(detailData.lastSeenAppVersion ?? "n/a"))"
            ),
            .init(
                key: "Platform",
                value: "\(detailData.lastSeenPlatform ?? "n/a") (\(detailData.lastSeenPlatformVersion ?? "n/a"))"
            ),
            .init(
                key: "SDK Version",
                value: detailData.lastSeenSDKVersion ?? "n/a"
            )
        ]
        
        entitlementItems = detailData.subscriptionStatuses?
            .map { .init(data: $0) }
            .sorted(by: { $0.type.rawValue < $1.type.rawValue })
        
        attributeItems = detailData.subscriberAttributes?
            .map { .init(key: $0.key ?? "n/a", value: $0.value ?? "n/a", copyable: true) } ?? []
        
        let detailHistoryItems = detailData.history?.compactMap { TransactionDetailHistoryItem(data: $0) } ?? []
        let activityHistoryItems = activityData?.events?.map { TransactionDetailHistoryItem(data: $0, appUserId: activityData?.appUserId ?? "") } ?? []
        let allHistoryItems = (detailHistoryItems + activityHistoryItems)
            .sorted(by: { ($0.timestamp ?? 0) > ($1.timestamp ?? 0) })
        historyItems = allHistoryItems
    }
}
