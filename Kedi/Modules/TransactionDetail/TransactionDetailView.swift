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
        List {
            if let items = viewModel.detailItems {
                Section {
                    ForEach(items) { item in
                        TransactionDetailInfoListView(item: item)
                    }
                } header: {
                    Text("Details")
                }
            }
            
            if let items = viewModel.entitlementItems {
                Section {
                    ForEach(items) { item in
                        TransactionDetailEntitlementListView(item: item)
                    }
                } header: {
                    Text("Entitlements")
                }
            }
            
            if let items = viewModel.attributeItems {
                Section {
                    ForEach(items) { item in
                        TransactionDetailInfoListView(item: item)
                    }
                } header: {
                    Text("Attributes")
                }
            }
            
            if let items = viewModel.historyItems {
                Section {
                    ForEach(items) { item in
                        TransactionDetailHistoryListView(item: item)
                    }
                } header: {
                    Text("History")
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TransactionDetailView(viewModel: .init(appId: "", subscriberId: ""))
}
