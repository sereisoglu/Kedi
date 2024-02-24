//
//  OverviewItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI

struct OverviewItemView: View {
    
    @State private var infoHeight: CGFloat = .zero
    
    let item: OverviewItem
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Label(item.name.uppercased(), systemImage: item.icon)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .labelStyle(SpacingLabelStyle(spacing: 2))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
//                    HStack(spacing: 2) {
//                        Image(item.icon)
//                        Text(item.name.uppercased())
//                    }
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                    .foregroundStyle(.secondary)
//                    .labelStyle(SpacingLabelStyle(spacing: 2))
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.5)
                    
                    Text(item.value.string)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .redacted(reason: item.isRedacted ? .placeholder : [])
                }
                .getSize { size in
                    infoHeight = size.height
                }
                
                if let note = item.note {
                    Text(note)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .zIndex(1)
            
            if let chartValues = item.chartValues {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: infoHeight)
                        .padding(.bottom)
                    
                    LineAndAreaMarkChartView(values: chartValues)
                }
            }
        }
        .background(Color.secondarySystemGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    OverviewItemView(item: .init(value: .mrr(123.323), config: .init(type: .mrr, timePeriod: .allTime)))
}
