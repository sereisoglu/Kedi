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
        VStack {
            makeBody()
                .aspectRatio(1, contentMode: .fit)
                .background(Color.secondarySystemGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .contentShape([.contextMenuPreview, .dragPreview], RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            Text(item.caption ?? " ")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        switch item.valueState {
        case .empty:
            makeInfoView(description: "Empty")
            
        case .error(let error):
            makeInfoView(description: error.localizedDescription)
            
        case .loading,
                .data:
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Image(systemName: item.icon)
                        Text(item.title.uppercased())
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
                    if let subtitle = item.subtitle {
                        VStack(alignment: .leading) {
                            Text(subtitle)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .zIndex(1)
                    }
                    
                    if let values = item.chart?.values {
                        OverviewItemChartView(values: values)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    private func makeInfoView(description: String) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 2) {
                Image(systemName: item.icon)
                Text(item.title.uppercased())
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Text(description)
                .foregroundStyle(.red)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    OverviewItemView(item: .init(
        config: .init(type: .mrr, timePeriod: .allTime),
        value: .mrr(123.323),
        valueState: .data
    ))
}
