//
//  OverviewItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI

struct OverviewItemView: View {
    
    let item: OverviewItem
    var chartValues: [LineAndAreaMarkChartValue]? = nil
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Label(item.name.uppercased(), systemImage: item.icon)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .labelStyle(SpacingLabelStyle(spacing: 2))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Text(item.value)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                if let note = item.note {
                    Text(note)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            if let chartValues {
                VStack {
                    Spacer()
                        .frame(height: 60)
                    
                    LineAndAreaMarkChartView(values: chartValues)
                        .foregroundColor(.blue)
                }
            }
        }
        .background(Color.secondarySystemGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    OverviewItemView(item: .init(type: .mrr, value: ""))
}
