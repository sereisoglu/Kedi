//
//  OverviewItemDetailView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/24/24.
//

import SwiftUI

struct OverviewItemDetailView: View {
    
    @State private var configSelection: OverviewItemConfig
    
    @State private var item: OverviewItem
    
    init(item: OverviewItem) {
        self.item = item
        
        configSelection = item.config
    }
    
    var body: some View {
        List {
            Picker("Type", selection: $configSelection.type) {
                ForEach(OverviewItemType.allCases, id: \.self) { type in
                    Text(type.title)
                }
            }
            
            Picker("Time Period", selection: $configSelection.timePeriod) {
                ForEach(item.type.availableTimePeriods, id: \.self) { timePeriod in
                    Text(timePeriod.title)
                }
            }
        }
        .navigationTitle("Add / Edit")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.systemGroupedBackground)
        .safeAreaInset(edge: .top) {
            VStack(alignment: .center, spacing: 5) {
                OverviewItemView(item: .init(
                    config: configSelection,
                    value: OverviewItemValue.placeholder(type: configSelection.type),
                    valueState: .data,
                    chartValues: .placeholder
                ))
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 200, height: 200)
                
                Text("Example")
                    .font(.footnote)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
            .background(Color.systemGroupedBackground)
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    OverviewItemDetailView(item: .init(
        config: .init(type: .mrr, timePeriod: .allTime),
        value: .mrr(123.323),
        valueState: .data
    ))
}

