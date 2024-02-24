//
//  OverviewView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct OverviewView: View {
    
    @StateObject private var viewModel = OverviewViewModel()
    
    var body: some View {
        makeBody()
            .navigationTitle("Overview")
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
            ScrollView {
                LazyVGrid(
                    columns: [.init(.adaptive(minimum: 165))],
                    spacing: 12
                ) {
                    ForEach(viewModel.getItems()) { item in
                        NavigationLink(value: item) {
                            OverviewItemView(item: item)
                                .aspectRatio(1, contentMode: .fit)
                        }
                        .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationDestination(for: OverviewItem.self) { item in
//                OverviewDetailView(item: item, chartValues: viewModel.chartValues[item.type])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Remove") {
                        viewModel.removeItem()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.addItem()
                    }
                }
            }
        }
    }
}

#Preview {
    OverviewView()
}
