//
//  PurchaseManager.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/18/24.
//

import Foundation
import RevenueCat

@MainActor
final class PurchaseManager: NSObject, ObservableObject {
    
    enum PurchaseError: Error {
        
        case isPurchasing
        case packageNotFound
        case unknown(Error)
    }
    
    private var revenueCat: Purchases {
        Purchases.shared
    }
    
    private var purchases = [PurchaseModel]()
    
    @Published private(set) var meSubscriptionType: MeSubscriptionType = .normal
    @Published private(set) var meSubscription: MeSubscriptionModel?
    @Published private(set) var meNonSubscriptions: [MeNonSubscriptionModel]?
    
    @Published private(set) var state: GeneralState = .loading
    @Published private(set) var isPurchasing = false
    
    static let shared = PurchaseManager()
    
    private override init() {}
    
    // MARK: - configure
    
    func start() {
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_cOuJUpHbyDbiNsEACaSKfqXwKlq")
        
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
                
                state = .data
            } catch {
                state = .error(error)
            }
        }
    }
    
    // MARK: - attribution
    
    func signOut() async throws {
        let info = try await revenueCat.logOut()
        processInfo(info: info)
    }
    
    // MARK: - actions
    
    func makePurchase(productType: PurchaseProductType) async throws {
        guard let purchase = purchases.first(where: { $0.productType == productType }) else {
            throw PurchaseError.packageNotFound
        }
        try await makePurchase(purchase)
    }
    
    func makePurchase(_ purchase: PurchaseModel) async throws {
        guard !isPurchasing else {
            throw PurchaseError.isPurchasing
        }
        isPurchasing = true
        
        defer { isPurchasing = false }
        
        let data = try await revenueCat.purchase(package: purchase.package)
        
        if !data.userCancelled {
            processInfo(info: data.customerInfo)
        }
    }
    
    func restorePurchase() async throws {
        let info = try await revenueCat.restorePurchases()
        processInfo(info: info)
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
        processInfo(info: info)
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
    
    func getTotalSpendForTips() -> String {
        let totalSpend: Decimal = meNonSubscriptions?.reduce(0, { partialResult, nonSubscription in
            partialResult + nonSubscription.price
        }) ?? 0
        
        guard totalSpend > 0,
              let localizedPriceString = purchases.first?.package.storeProduct.priceFormatter?.string(from: totalSpend as NSNumber) else {
            return "You haven't made a tip."
        }
        
        return "You've tipped \(localizedPriceString) so far.\n❤️ Thanks for your support!"
    }
    
    // MARK: - processInfo
    
    private func processInfo(info: CustomerInfo) {
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
    
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        print("purchases: receivedUpdated:", customerInfo)
        
        guard !isPurchasing else {
            return
        }
        
        processInfo(info: customerInfo)
    }
    
    // itms-services://?action=purchaseIntent&bundleId=com.sereisoglu.kedi&productIdentifier=kedi.supporter.monthly
    func purchases(_ purchases: Purchases, readyForPromotedProduct product: StoreProduct, purchase startPurchase: @escaping StartPurchaseBlock) {
        guard !isPurchasing else {
            return
        }
        isPurchasing = true
        
        startPurchase { [weak self] (_, info, _, _) in
            guard let self else {
                return
            }
            isPurchasing = false
            
            if let info {
                processInfo(info: info)
            }
        }
    }
}
