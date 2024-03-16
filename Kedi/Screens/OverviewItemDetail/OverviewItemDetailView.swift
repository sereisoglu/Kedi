//
//  OverviewItemDetailView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import SwiftUI

struct OverviewItemDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var superViewModel: OverviewViewModel
    @StateObject var viewModel: OverviewItemDetailViewModel
    
    var body: some View {
        List {
            if viewModel.configState == .notAvailable {
                GeneralListView(
                    imageAsset: .systemImage("exclamationmark.triangle"),
                    title: viewModel.notAvailableMessage,
                    accessoryImageSystemName: nil
                )
                .foregroundStyle(.red)
            }
            
            Section {
                switch viewModel.action {
                case .add:
                    Picker("Type", selection: $viewModel.configSelection.type) {
                        ForEach(OverviewItemType.allCases, id: \.self) { type in
                            Text(type.title)
                        }
                    }
                case .edit:
                    HStack {
                        Text("Type")
                        Spacer()
                        Text(viewModel.configSelection.type.title)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Picker("Time Period", selection: $viewModel.configSelection.timePeriod) {
                    ForEach(viewModel.configSelection.type.availableTimePeriods, id: \.self) { timePeriod in
                        Text(timePeriod.title)
                    }
                }
            }
            
            if case .edit(let config) = viewModel.action {
                Section {
                    Button {
                        superViewModel.removeItem(config: config)
                        dismiss()
                    } label: {
                        Text("Remove")
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .navigationTitle(viewModel.configSelection.type.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.systemGroupedBackground)
        .safeAreaInset(edge: .top) {
            VStack(alignment: .center) {
                OverviewItemView(item: .init(
                    config: viewModel.configSelection,
                    value: .placeholder(type: viewModel.configSelection.type),
                    valueState: .data,
                    chart: .init(values: .placeholder)
                ))
                .frame(width: 200)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
            .background {
                Color.systemGroupedBackground
                    .overlay(Color.primary.opacity(0.1))
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                switch viewModel.action {
                case .add:
                    Button("Add") {
                        superViewModel.addItem(config: viewModel.configSelection)
                        dismiss()
                    }
                    .disabled(viewModel.configState.disabled)
                case .edit(let config):
                    Button("Save") {
                        superViewModel.updateItem(config: config, timePeriod: viewModel.configSelection.timePeriod)
                        dismiss()
                    }
                    .disabled(viewModel.configState.disabled)
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    OverviewItemDetailView(viewModel: .init(config: .init(type: .mrr, timePeriod: .allTime)))
}
