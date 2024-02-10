//
//  OverviewView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct OverviewView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject private var viewModel = OverviewViewModel()
    
    var body: some View {
        NavigationStack {
            getBody()
                .navigationTitle("Overview")
                .background(Color.systemGroupedBackground)
                .refreshable {
                    await viewModel.refresh()
                }
        }
    }
    
    @ViewBuilder
    private func getBody() -> some View {
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
                    columns: .init(
                        repeating: .init(.flexible(), spacing: 12),
                        count: horizontalSizeClass == .compact ? 2 : 3
                    ),
                    spacing: 12
                ) {
                    ForEach(viewModel.items, id: \.self) { item in
                        OverviewItemView(item: item, chartValues: viewModel.chartValues[item.type])
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .redacted(reason: viewModel.state == .loading ? .placeholder : [])
            .disabled(viewModel.state == .loading)
        }
    }
}

#Preview {
    OverviewView()
}
