//
//  TransactionsViewModel.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import Foundation

final class TransactionsViewModel: ObservableObject {
    
    private let apiService = APIService.shared
    
    @Published var transactions = [TransactionSection]()
    
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
                endpoint: .transactions(.init())
            )
            
            let groupedTransactions = Dictionary(grouping: data?.transactions ?? []) { transaction in
                DateFormatter.iso8601WithoutMilliseconds.date(from: transaction.purchaseDate ?? "")?.withoutTime
            }
            
            transactions = groupedTransactions
                .compactMap { date, transactions in
                    guard let date else {
                        return nil
                    }
                    return .init(date: date, transactions: transactions.map { .init(data: $0) })
                }
                .sorted(by: { $0.date > $1.date })
        } catch {
            print(error)
        }
    }
}
