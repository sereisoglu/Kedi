//
//  OverviewScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct OverviewScreen: View {
    
    @EnvironmentObject var meManager: MeManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    @StateObject private var viewModel = OverviewViewModel()
    
    @State private var contextMenuItem: OverviewItem?
    @State private var draggingItem: OverviewItem?
    @State private var showingAddItem = false
    @State private var showingRestoreDefaultsAlert = false
    
    var body: some View {
        ScrollView {
            makeBody()
        }
        .navigationTitle("Overview")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        showingAddItem = true
                    }
                } label: {
                    Image(systemName: "plus.square")
                }
            }
        }
        .navigationDestination(for: OverviewItem.self) { item in
            OverviewDetailScreen(viewModel: .init(item: item))
        }
        .sheet(isPresented: $showingAddItem) {
            NavigationStack {
                OverviewItemDetailScreen(viewModel: .init(config: nil))
                    .environmentObject(viewModel)
            }
        }
        .sheet(item: $contextMenuItem) { item in
            NavigationStack {
                OverviewItemDetailScreen(viewModel: .init(config: item.config))
                    .environmentObject(viewModel)
            }
        }
        .overlay(content: makeStateView)
        .scrollContentBackground(viewModel.state == .data ? .automatic : .hidden)
        .background(Color.systemGroupedBackground)
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        if viewModel.state == .data {
            if !userDefaultsManager.isRequestReviewClosed {
                RequestReviewView()
                    .background(Color.secondarySystemGroupedBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.horizontal)
                    .padding(.bottom)
            } else {
                if purchaseManager.state == .data,
                   purchaseManager.meSubscription == nil {
                    VStack(spacing: 0) {
                        BecomeSupporterView(
                            title: "Become a Supporter!",
                            subtitle: "Support indie development",
                            isActive: true
                        )
                        Text("Kedi is a free and [open-source \(Text(imageSystemName: "arrow.up.forward").foregroundStyle(.accent))](https://github.com/sereisoglu/Kedi) RevenueCat client. Kedi was build by a solo [developer \(Text(imageSystemName: "arrow.up.forward").foregroundStyle(.accent))](https://x.com/sereisoglu). If Kedi has made your life easier and you want to support future development, you can become a supporter!")
                            .padding(.horizontal)
                            .font(.footnote.leading(.tight))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            
            LazyVGrid(
                columns: [.init(.adaptive(minimum: 165), alignment: .top)],
                spacing: 12
            ) {
                ForEach(viewModel.getItems()) { item in
                    if item.chart == nil {
                        makeItem(item: item)
                    } else {
                        NavigationLink(value: item) {
                            makeItem(item: item)
                        }
                        .buttonStyle(StandardButtonStyle())
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            Button {
                showingRestoreDefaultsAlert = true
            } label: {
                Label("Restore Defaults", systemImage: "clock.arrow.circlepath")
                    .font(.subheadline)
            }
            .disabled(viewModel.isRestoreDefaultsDisabled)
            .confirmationDialog(
                "Restore Defaults",
                isPresented: $showingRestoreDefaultsAlert
            ) {
                Button("Cancel", role: .cancel) {}
                Button("Yes", role: .destructive) {
                    withAnimation {
                        viewModel.restoreDefaults()
                    }
                }
            } message: {
                Text("Are you sure you want to restore the default settings?")
            }
            .padding(.bottom)
        } else {
            Color.clear
        }
    }
    
    private func makeItem(item: OverviewItem) -> some View {
        OverviewItemView(item: item)
            .contextMenu {
                Section(item.chart?.updatedAtFormatted ?? "") {
                    Button {
                        contextMenuItem = item
                    } label: {
                        Label("Edit", systemImage: "slider.horizontal.3")
                    }
                    
                    Button(role: .destructive) {
                        withAnimation {
                            viewModel.removeItem(config: item.config)
                        }
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
            .onDrag {
                draggingItem = item
                return NSItemProvider(object: item.id as NSString)
            } preview: {
                Color.clear
                    .frame(width: 0.5, height: 0.5)
            }
            .onDrop(
                of: [.text],
                delegate: OverviewDropDelegate(
                    viewModel: viewModel,
                    item: item,
                    draggingItem: $draggingItem
                )
            )
    }
    
    @ViewBuilder
    private func makeStateView() -> some View {
        switch viewModel.state {
        case .empty:
            ContentUnavailableView(
                "Empty",
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
    OverviewScreen()
}
