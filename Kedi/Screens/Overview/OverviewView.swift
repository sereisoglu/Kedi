//
//  OverviewView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct OverviewView: View {
    
    @StateObject private var viewModel = OverviewViewModel()
    
    @State private var activeItem: OverviewItem?
    
    var body: some View {
        makeBody()
            .navigationTitle("Overview")
            .background(Color.systemGroupedBackground)
            .sheet(item: $activeItem) { item in
                NavigationStack {
                    OverviewItemDetailView(item: item)
                }
            }
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
                                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .contextMenu {
                                    Button {
                                        activeItem = item
                                    } label: {
                                        Label("Edit", systemImage: "slider.horizontal.3")
                                    }
                                    
                                    Button(role: .destructive) {
                                        print("Remove", item.type.title)
                                    } label: {
                                        Label("Remove", systemImage: "trash")
                                    }
                                }
                        }
                        .buttonStyle(StandardButtonStyle())
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
