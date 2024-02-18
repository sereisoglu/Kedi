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
    
    enum PurchaseState {
        
        case loading
        case data
        case error(PurchaseError)
    }
    
    enum PurchaseError: Error {
        
        case isPurchasing
        case packageNotFound
        case unknown(Error)
    }
    
    private var revenueCat: Purchases {
        Purchases.shared
    }
    
    @Published private var purchases = [PurchaseModel]()
    
    @Published private(set) var meSubscription: MeSubscriptionModel?
    @Published private(set) var meNonSubscription: [MeNonSubscriptionModel]?
    
    @Published private(set) var state: PurchaseState = .loading
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
                state = .error(.unknown(error))
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
        
        let data = try await revenueCat.purchase(package: purchase.package)
        
        if !data.userCancelled {
            processInfo(info: data.customerInfo)
        }
        isPurchasing = false
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
    
    func getSubscriptions() -> [PurchaseModel] {
        purchases.filter { $0.productType.entitlement == .supporter }
    }
    
    func getNonSubscriptions() -> [PurchaseModel] {
        purchases.filter { $0.productType.entitlement == .tip }
    }
    
    private func fetchPurchases() async throws {
        let offering = (try await revenueCat.offerings()).current
        purchases = offering?.availablePackages.compactMap { .init(package: $0) } ?? []
    }
    
    private func fetchMePurchases() async throws {
        let info = try await revenueCat.customerInfo()
        processInfo(info: info)
    }
    
    // MARK: - processInfo
    
    private func processInfo(info: CustomerInfo) {
        meNonSubscription = info.nonSubscriptions.compactMap { nonSubscription in
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
                      let purchaseDate = entitlement.latestPurchaseDate else {
                    return nil
                }
                
                return .init(
                    productType: productType,
                    purchaseDate: purchaseDate,
                    expirationDate: entitlement.expirationDate,
                    willRenew: entitlement.willRenew
                )
            }
            .sorted(by: { ($0.productType.rank ?? .max) > ($1.productType.rank ?? .max) })
            .first
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

struct MeSubscriptionModel {
    
    var productType: PurchaseProductType
    var purchaseDate: Date
    var expirationDate: Date?
    var willRenew: Bool
}

struct MeNonSubscriptionModel {
    
    var productType: PurchaseProductType
    var purchaseDate: Date
    var price: Decimal
}

struct PurchaseModel: Identifiable, Hashable {
    
    let id = UUID()
    var package: Package
    var productType: PurchaseProductType
    
    var localizedPriceString: String {
        package.storeProduct.localizedPriceString
    }
    
    var price: Decimal {
        package.storeProduct.price
    }
    
    init?(package: Package) {
        guard let productType = PurchaseProductType(rawValue: package.storeProduct.productIdentifier) else {
            return nil
        }
        
        self.package = package
        self.productType = productType
    }
}

enum PurchaseProductType: String {
    
    case supporterMonthly = "kedi.supporter.monthly"
    case fullSupporterMonthly = "kedi.fullSupporter.monthly"
    case superSupporterMonthly = "kedi.superSupporter.monthly"
    
    case smallTip = "kedi.smallTip"
    case niceTip = "kedi.niceTip"
    case generousTip = "kedi.generousTip"
    case hugeTip = "kedi.hugeTip"
    
    var emoji: String {
        switch self {
        case .supporterMonthly: ""
        case .fullSupporterMonthly: ""
        case .superSupporterMonthly: ""
        case .smallTip: "🍪"
        case .niceTip: "☕️"
        case .generousTip: "🍔"
        case .hugeTip: "🚀"
        }
    }
    
    var name: String {
        switch self {
        case .supporterMonthly: "Supporter Monthly"
        case .fullSupporterMonthly: "Full Supporter Monthly"
        case .superSupporterMonthly: "Super Supporter Monthly"
        case .smallTip: "Small Tip"
        case .niceTip: "Nice Tip"
        case .generousTip: "Generous Tip"
        case .hugeTip: "Huge Tip"
        }
    }
    
    var rank: Int? {
        switch self {
        case .supporterMonthly: 1
        case .fullSupporterMonthly: 2
        case .superSupporterMonthly: 3
        default: nil
        }
    }
    
    var entitlement: PurchaseEntitlement {
        switch self {
        case .supporterMonthly,
                .fullSupporterMonthly,
                .superSupporterMonthly:
            return .supporter
        case .smallTip,
                .niceTip,
                .generousTip,
                .hugeTip:
            return .tip
        }
    }
}
    
enum PurchaseEntitlement: String {
    
    case supporter
    case tip
    
    var name: String {
        rawValue.uppercased()
    }
}
