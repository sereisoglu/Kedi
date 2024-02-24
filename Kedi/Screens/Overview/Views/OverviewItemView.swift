//
//  OverviewItemView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/7/24.
//

import SwiftUI

struct OverviewItemView: View {
    
    let item: OverviewItem
    
    var body: some View {
        makeBody()
            .background(Color.secondarySystemGroupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        switch item.valueState {
        case .loading,
                .empty,
                .data:
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Image(systemName: item.icon)
                        Text(item.name.uppercased())
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    
                    Text(item.value.formatted)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .redacted(reason: item.valueState == .loading ? .placeholder : [])
                }
                .padding(.horizontal)
                .padding(.top)
                
                ZStack(alignment: .leading) {
                    if let note = item.note {
                        VStack(alignment: .leading) {
                            Text(note)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .zIndex(1)
                    }
                    
                    if let chartValues = item.chartValues {
                        LineAndAreaMarkChartView(values: chartValues)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        case .error(let error):
            VStack(alignment: .leading) {
                HStack(spacing: 2) {
                    Image(systemName: item.icon)
                    Text(item.name.uppercased())
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

#Preview {
    OverviewItemView(item: .init(
        config: .init(type: .mrr, timePeriod: .allTime),
        value: .mrr(123.323),
        valueState: .data
    ))
}
