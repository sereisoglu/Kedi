//
//  TransactionsScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/5/24.
//

import SwiftUI

struct TransactionsScreen: View {
    
    @StateObject private var viewModel = TransactionsViewModel()
    
    var body: some View {
        List {
            makeBody()
        }
        .navigationTitle("Transactions")
        .navigationDestination(for: TransactionItem.self) { transaction in
            TransactionDetailScreen(viewModel: .init(projectId: transaction.projectId, subscriberId: transaction.subscriberId))
        }
        .overlay(content: makeStateView)
        .scrollContentBackground(viewModel.state == .data ? .automatic : .hidden)
        .background(Color.systemGroupedBackground)
        .redacted(reason: viewModel.state == .loading ? .placeholder : [])
        .disabled(viewModel.state == .loading)
        .refreshableWithoutCancellation { await viewModel.refresh() }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
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
            .listSectionSpacing(.compact)
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
                            withOptionalAnimation {
                                viewModel.fetchTransactionsForPagination()
                            }
                        }
                    }
                
            case .error(let error):
                ContentUnavailableView {
                    Text("Error")
                } description: {
                    Text(error.displayableLocalizedDescription)
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                
            case .done:
                EmptyView()
                    .listRowBackground(Color.clear)
            }
        }
    }
    
    @ViewBuilder
    private func makeStateView() -> some View {
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
                description: Text(error.displayableLocalizedDescription)
            )
            
        case .loading,
                .data:
            EmptyView()
        }
    }
}

#Preview {
    TransactionsScreen()
}
