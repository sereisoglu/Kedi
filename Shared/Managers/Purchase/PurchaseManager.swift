//
//  PurchaseManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/18/24.
//

import SwiftUI
import RevenueCat

final class PurchaseManager: NSObject, ObservableObject {
    
    private var revenueCat: Purchases {
        Purchases.shared
    }
    
    private var purchases = [PurchaseModel]()
    
    @Published private(set) var meSubscriptionType: MeSubscriptionType = .normal
    @Published private(set) var meSubscription: MeSubscriptionModel?
    @Published private(set) var meNonSubscriptions: [MeNonSubscriptionModel]?
    
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var isPurchasing = false
    
    var userId: String {
        revenueCat.appUserID
    }
    
    static let shared = PurchaseManager()
    
    private override init() {}
    
    // MARK: - configure
    
    func start() {
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: EnvVars.revenueCat)
        
        revenueCat.delegate = self
        
        Task {
            do {
                try await withThrowingDiscardingTaskGroup { group in
                    group.addTask { [weak self] in
                        try await self?.fetchPurchases()
                    }
                    group.addTask { [weak self] in
                        try await self?.fetchMePurchases()
                    }
                }
                await MainActor.run { withOptionalAnimation { state = .data } }
            } catch {
                await MainActor.run { withOptionalAnimation { state = .error(error) } }
            }
        }
    }
    
    // MARK: - attribution
    
    func signIn(id: String) async throws {
        let info = try await revenueCat.logIn(id)
        await process(info: info.customerInfo)
    }
    
    func setKid(_ kid: String) {
        revenueCat.attribution.setAttributes(["kid": kid])
    }
    
    func setOneSignalId(_ id: String?) {
        revenueCat.attribution.setOnesignalUserID(id)
    }
    
    func setPushDeviceToken(_ token: Data) {
        revenueCat.attribution.setPushToken(token)
    }
    
    func signOut() async throws {
        let info = try await revenueCat.logOut()
        await process(info: info)
    }
    
    // MARK: - actions
    
    func makePurchase(productType: PurchaseProductType) async throws {
        guard let purchase = purchases.first(where: { $0.productType == productType }) else {
            throw PurchaseError.packageNotFound
        }
        try await makePurchase(purchase)
    }
    
    @MainActor
    func makePurchase(_ purchase: PurchaseModel) async throws {
        guard !isPurchasing else {
            throw PurchaseError.isPurchasing
        }
        isPurchasing = true
        
        defer { isPurchasing = false }
        
        let data = try await revenueCat.purchase(package: purchase.package)
        
        if !data.userCancelled {
            process(info: data.customerInfo)
            NotificationCenter.default.post(name: .purchase, object: purchase.productType.rawValue)
        }
    }
    
    func restorePurchase() async throws {
        let info = try await revenueCat.restorePurchases()
        if info.activeSubscriptions.isEmpty && info.nonSubscriptions.isEmpty {
            throw PurchaseError.purchaseNotFound
        }
        await process(info: info)
    }
    
    func redeemCode() {
        revenueCat.presentCodeRedemptionSheet()
    }
    
    func showManageSubscriptions() async throws {
        try await revenueCat.showManageSubscriptions()
    }
    
    // MARK: - purchases
    
    private func fetchPurchases() async throws {
        let offering = (try await revenueCat.offerings()).current
        purchases = offering?.availablePackages.compactMap { .init(package: $0) } ?? []
    }
    
    private func fetchMePurchases() async throws {
        let info = try await revenueCat.customerInfo()
        await process(info: info)
    }
    
    func getSubscriptions() -> [PurchaseModel] {
        purchases.filter { purchase in
            guard purchase.productType.entitlement == .supporter,
                  let level = purchase.productType.level else {
                return false
            }
            return level > (meSubscription?.productType.level ?? 0)
        }
    }
    
    func getNonSubscriptions() -> [PurchaseModel] {
        purchases.filter { $0.productType.entitlement == .tip }
    }
    
    func getNonSubscriptionsTotalSpent() -> String? {
        let totalSpent: Decimal = meNonSubscriptions?.reduce(0, { partialResult, nonSubscription in
            partialResult + nonSubscription.price
        }) ?? 0
        
        guard totalSpent > 0,
              let localizedPriceString = purchases.first?.package.storeProduct.priceFormatter?.string(from: totalSpent as NSNumber) else {
            return nil
        }
        
        return localizedPriceString
    }
    
    // MARK: - processInfo
    
    @MainActor
    private func process(info: CustomerInfo) {
        meNonSubscriptions = info.nonSubscriptions.compactMap { nonSubscription in
            guard let productType = PurchaseProductType(rawValue: nonSubscription.productIdentifier),
                  let purchase = purchases.first(where: { $0.productType == productType }) else {
                return nil
            }
            return .init(
                productType: productType,
                purchaseDate: nonSubscription.purchaseDate,
                price: purchase.package.storeProduct.price
            )
        }
        
        meSubscription = info.activeSubscriptions
            .compactMap { productIdentifier in
                guard let productType = PurchaseProductType(rawValue: productIdentifier),
                      let entitlement = info.entitlements[productType.entitlement.rawValue],
                      let purchaseDate = entitlement.latestPurchaseDate,
                      let expirationDate = entitlement.expirationDate else {
                    return nil
                }
                return .init(
                    productType: productType,
                    purchaseDate: purchaseDate,
                    expirationDate: expirationDate,
                    willRenew: entitlement.willRenew
                )
            }
            .sorted(by: { ($0.productType.level ?? 0) > ($1.productType.level ?? 0) })
            .first
        
        meSubscriptionType = .init(productType: meSubscription?.productType)
    }
}

extension PurchaseManager: PurchasesDelegate {
    
//    @MainActor
    func purchases(
        _ purchases: Purchases,
        receivedUpdated customerInfo: CustomerInfo
    ) {
        print("purchases: receivedUpdated:", customerInfo)
        guard !isPurchasing else {
            return
        }
        Task {
            await process(info: customerInfo)
        }
    }
    
    // itms-services://?action=purchaseIntent&bundleId=com.sereisoglu.kedi&productIdentifier=kedi.supporter.monthly
    func purchases(
        _ purchases: Purchases,
        readyForPromotedProduct product: StoreProduct,
        purchase startPurchase: @escaping StartPurchaseBlock
    ) {
        guard !isPurchasing else {
            return
        }
        isPurchasing = true
        
        startPurchase { [weak self] _, info, _, _ in
            guard let self else {
                return
            }
            isPurchasing = false
            
            if let info {
                process(info: info)
            }
        }
    }
}
