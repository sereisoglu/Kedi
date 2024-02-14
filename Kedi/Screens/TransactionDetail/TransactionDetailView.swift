//
//  TransactionDetailView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/6/24.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @StateObject var viewModel: TransactionDetailViewModel
    
    var body: some View {
        makeBody()
            .navigationTitle(viewModel.navigationTitle)
            .background(Color.systemGroupedBackground)
            .navigationBarTitleDisplayMode(.inline)
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
                if let items = viewModel.detailItems {
                    Section {
                        ForEach(items) { item in
                            TransactionDetailInfoItemView(item: item)
                        }
                    } header: {
                        Text("Details")
                    }
                }
                
                if let items = viewModel.entitlementItems {
                    Section {
                        ForEach(items) { item in
                            TransactionDetailEntitlementItemView(item: item)
                        }
                    } header: {
                        Text("Entitlements")
                    }
                }
                
                if let items = viewModel.attributeItems {
                    Section {
                        ForEach(items) { item in
                            TransactionDetailInfoItemView(item: item)
                        }
                    } header: {
                        Text("Attributes")
                    }
                }
                
                if let items = viewModel.historyItems {
                    Section {
                        ForEach(items) { item in
                            TransactionDetailHistoryItemView(item: item)
                        }
                    } header: {
                        Text("History")
                    }
                }
            }
            .redacted(reason: viewModel.state == .loading ? .placeholder : [])
            .disabled(viewModel.state == .loading)
        }
    }
}

#Preview {
    TransactionDetailView(viewModel: .init(appId: "", subscriberId: ""))
}
