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
        makeBody()
            .navigationTitle("Transactions")
            .background(Color.systemGroupedBackground)
            .refreshable {
                await viewModel.refresh()
            }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        switch viewModel.state {
        case .empty:
            ContentUnavailableView(
                "No Data",
                systemImage: "xmark.circle"
            )
            
        case .error(let error):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(error.localizedDescription)
            )
            
        case .loading,
                .data:
            List {
                ForEach(viewModel.transactionSections) { section in
                    Section {
                        ForEach(section.transactions) { transaction in
                            NavigationLink(value: transaction) {
                                TransactionItemView(transaction: transaction)
                            }
                        }
                    } header: {
                        HStack {
                            Text(section.date.format(to: .EEE_MMM_d_yyyy))
                            Spacer()
                            Text(section.revenue.formatted(.currency(code: "USD")))
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                
                if viewModel.state == .data {
                    switch viewModel.paginationState {
                    case .idle,
                            .paginating:
                        ProgressView()
                            .id(viewModel.paginationState.id)
                            .controlSize(.regular)
                            .frame(maxWidth: .infinity)
                            .listRowInsets(.zero)
                            .listRowBackground(Color.clear)
                            .onAppear {
                                if viewModel.paginationState == .idle {
                                    withAnimation {
                                        viewModel.fetchTransactionsForPagination()
                                    }
                                }
                            }
                        
                    case .error(let error):
                        ContentUnavailableView {
                            Text("Error")
                        } description: {
                            Text(error.localizedDescription)
                        }
                        .listRowInsets(.zero)
                        .listRowBackground(Color.clear)
                        
                    case .done:
                        EmptyView()
                            .listRowBackground(Color.clear)
                    }
                }
            }
            .navigationDestination(for: TransactionItem.self) { transaction in
                TransactionDetailView(viewModel: .init(appId: transaction.appId, subscriberId: transaction.subscriberId))
            }
            .redacted(reason: viewModel.state == .loading ? .placeholder : [])
            .disabled(viewModel.state == .loading)
        }
    }
}

#Preview {
    TransactionsView()
}
