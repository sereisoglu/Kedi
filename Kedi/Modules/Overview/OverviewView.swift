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
    
    private var items: [OverviewItem] {
        viewModel.items
    }
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("Overview")
                    .background(Color.systemGroupedBackground)
                
            case .empty:
                ContentUnavailableView("No Data", systemImage: "xmark.circle")
                    .navigationTitle("Overview")
                    .background(Color.systemGroupedBackground)
                
            case .error(let error):
                ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(error.localizedDescription))
                    .navigationTitle("Overview")
                    .background(Color.systemGroupedBackground)
                
            case .data:
                ScrollView {
                    LazyVGrid(
                        columns: .init(
                            repeating: .init(.flexible(), spacing: 12),
                            count: horizontalSizeClass == .compact ? 2 : 3
                        ),
                        spacing: 12
                    ) {
                        ForEach(items, id: \.self) { item in
                            makeItemView(item: item)
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                    .padding(.init(top: 0, leading: 20, bottom: 20, trailing: 20))
                }
                .navigationTitle("Overview")
                .background(Color.systemGroupedBackground)
            }
        }
    }
    
    private func makeItemView(
        item: OverviewItem
    ) -> some View {
        VStack(alignment: .leading) {
            Text(item.name.uppercased())
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text(item.value)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            if let note = item.note {
                Text(note)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.systemBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
    }
}

#Preview {
    OverviewView()
}
