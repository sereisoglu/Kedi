//
//  TransactionsViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import Foundation

final class TransactionsViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    
    private var transactions = [RCTransaction]()
    private var startFrom: Int?
    
    @Published private(set) var state: GeneralState = .loading
    @Published private(set) var paginationState: PaginationState = .idle
    
    @Published private(set) var transactionSections: [TransactionSection] = .stub
    
    init() {
        Task {
            await fetchTransactions()
        }
    }
    
    @MainActor
    private func fetchTransactions() async {
        do {
            let data = try await apiService.request(
                type: RCTransactionsResponse.self,
                endpoint: .transactions(.init(
                    limit: 100,
                    endDate: Date(byAdding: .day, value: 7).format(to: .yyy_MM_dd)
                ))
            )
            
            transactions = data?.transactions ?? []
            startFrom = data?.lastPurchaseMs
            
            transactionSections = getSections(transactions: transactions)
            
            state = .data
        } catch {
            transactionSections = []
            state = .error(error)
        }
    }
    
    @MainActor
    func fetchTransactionsForPagination() {
        guard state == .data,
              paginationState == .idle else {
            return
        }
        paginationState = .paginating
        
        Task {
            do {
                let data = try await apiService.request(
                    type: RCTransactionsResponse.self,
                    endpoint: .transactions(.init(
                        limit: 100,
                        startFrom: startFrom
                    ))
                )

                if data?.transactions?.isEmpty ?? true {
                    paginationState = .done
                } else {
                    transactions += data?.transactions ?? []
                    startFrom = data?.lastPurchaseMs

                    transactionSections = getSections(transactions: transactions)

                    paginationState = .idle
                }
            } catch {
                paginationState = .error(error)
            }
        }
    }
    
    private func getSections(transactions: [RCTransaction]) -> [TransactionSection] {
        let groupedTransactions = Dictionary(grouping: transactions) { transaction in
            transaction.purchaseDate?.format(to: .iso8601WithoutMilliseconds)?.withoutTime
        }
        
        return groupedTransactions
            .compactMap { date, transactions in
                guard let date else {
                    return nil
                }
                return .init(date: date, transactions: transactions.map { .init(data: $0) })
            }
            .sorted(by: { $0.date > $1.date })
    }
    
    func refresh() async {
        await fetchTransactions()
    }
}
