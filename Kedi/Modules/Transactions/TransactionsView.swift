//
//  TransactionsView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import SwiftUI

struct TransactionsView: View {
    
    @StateObject private var viewModel = TransactionsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.transactions) { dailyTransactions in
                    Section {
                        ForEach(dailyTransactions.transactions) { transaction in
                            NavigationLink(value: transaction) {
                                TransactionListView(transaction: transaction)
                            }
                        }
                    } header: {
                        HStack {
                            Text(dailyTransactions.date.format(dateFormatter: .EEE_MMM_d_yyyy))
                            
                            Spacer()
                            
                            Text(dailyTransactions.revenue.formatted(.currency(code: "USD")))
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationDestination(for: TransactionModel.self) { transaction in
                TransactionDetailView(viewModel: .init(appId: transaction.appId, subscriberId: transaction.subscriberId))
            }
        }
    }
}

#Preview {
    TransactionsView()
}
