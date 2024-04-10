//
//  TransactionDetailViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import Foundation

final class TransactionDetailViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    private let meManager = MeManager.shared
    
    @Published private(set) var state: GeneralState = .loading
    
    @Published private(set) var navigationTitle: String = ""
    @Published private(set) var detailItems: [TransactionDetailInfoItem]?
    @Published private(set) var entitlementItems: [TransactionDetailEntitlementItem]?
    @Published private(set) var insightItems: [TransactionDetailInsightItem]?
    @Published private(set) var attributeItems: [TransactionDetailInfoItem]?
    @Published private(set) var historyItems: [TransactionDetailHistoryItem]?
    
    let projectId: String
    let subscriberId: String
    
    init(projectId: String, subscriberId: String) {
        self.projectId = projectId
        self.subscriberId = subscriberId
        
        set(detailData: .stub, activityData: .stub)
        navigationTitle = ""
        
        Task {
            await fetchDetail()
        }
    }
    
    init(appId: String, subscriberId: String) {
        guard let projectId = meManager.getProject(appId: appId)?.id else {
            self.projectId = ""
            self.subscriberId = ""
            self.state = .empty
            return
        }
        self.projectId = projectId
        self.subscriberId = subscriberId
        
        set(detailData: .stub, activityData: .stub)
        navigationTitle = ""
        
        Task {
            await fetchDetail()
        }
    }
    
    @MainActor
    private func fetchDetail() async {
        do {
            async let detailRequest = apiService.request(
                type: RCTransactionDetailResponse.self,
                endpoint: .transactionDetail(projectId: projectId, subscriberId: subscriberId)
            )
            
            async let activityRequest = apiService.request(
                type: RCTransactionDetailActivityResponse.self,
                endpoint: .transactionDetailActivity(projectId: projectId, subscriberId: subscriberId)
            )
            
            let (detailData, activityData) = try await (detailRequest, activityRequest)
            
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
                key: "Total Spent",
                value: detailData.dollarsSpent?.formatted(.currency(code: "USD")) ?? "n/a"
            ),
            .init(
                key: "Last Seen",
                value: detailData.lastSeen?.relativeDate(from: .iso8601WithoutMilliseconds)?.capitalizedSentence ?? "n/a"
            ),
            .init(
                key: "Created",
                value: detailData.createdAt?.relativeDate(from: .iso8601WithoutMilliseconds)?.capitalizedSentence ?? "n/a"
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
        
        if let items = historyItems?.reversed() {
            insightItems = []
            
            let refundCount = items.filter { $0.type.transactionType == .refund }.count
            
            if refundCount == 0,
               items.first?.type == .installation,
               let installationDate = items.first?.date,
               let firstPurchaseDate = items.first(where: { [.initialPurchase, .oneTimePurchase].contains($0.type.transactionType) })?.date {
                insightItems?.append(.init(
                    type: .firstPurchase,
                    text: "The user made the first purchase **with\(RelativeDateTimeFormatter.full.localizedString(for: firstPurchaseDate, relativeTo: installationDate))** of installing the app."
                ))
            }
            
            if refundCount == 0,
               let lastSeenTimestamp = detailData.lastSeen?.format(to: .iso8601WithoutMilliseconds)?.timeIntervalSince1970 {
                let filteredItems = items.filter { ($0.timestamp ?? 0) > lastSeenTimestamp && [.oneTimePurchase, .renewal, .conversion].contains($0.type.transactionType) }
                let spentDollars = filteredItems.reduce(0.0) { partialResult, item in
                    partialResult + (item.priceInUsd ?? 0)
                }
                if spentDollars > 0 {
                    insightItems?.append(.init(
                        type: .spentDollarsSinceLastSeen,
                        text: "The user spent **\(spentDollars.formatted(.currency(code: "USD")))** after the last seen. (\(filteredItems.count) transaction\(filteredItems.count > 1 ? "s" : ""))"
                    ))
                }
            }
            
            if refundCount > 0 {
                insightItems?.append(.init(
                    type: .refundCount,
                    text: "The user made a refund **\(refundCount) time\(refundCount > 1 ? "s" : "")** so far."
                ))
            }
            
            let transferCount = items.filter { item in
                guard case .transfer(let isFrom, _) = item.type else {
                    return false
                }
                return isFrom
            }.count
            if transferCount > 0 {
                insightItems?.append(.init(
                    type: .transferCount,
                    text: "The user made a transfer to another user **\(transferCount) time\(refundCount > 1 ? "s" : "")** so far."
                ))
            }
            
            if insightItems?.isEmpty ?? false {
                insightItems = nil
            }
        }
    }
}
