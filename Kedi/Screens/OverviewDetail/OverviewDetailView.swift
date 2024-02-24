////
////  OverviewDetailView.swift
////  Kedi
////
////  Created by Saffet Emin Reisoğlu on 2/19/24.
////
//
//import SwiftUI
//
//struct OverviewDetailView: View {
//    
//    @State private var infoHeight: CGFloat = .zero
//    
//    let item: OverviewItem
//    var chartValues: [LineAndAreaMarkChartValue]? = nil
//    
//    init(item: OverviewItem, chartValues: [LineAndAreaMarkChartValue]? = nil) {
//        self.item = item
//        self.chartValues = chartValues
//    }
//    
//    var body: some View {
//        List {
//            ForEach(Array((chartValues ?? []).reversed().enumerated()), id: \.offset) { index, value in
//                HStack {
//                    Text(value.value.formatted(.currency(code: "USD")))
//                        .font(.callout)
//                        .foregroundStyle(.primary)
//                    
//                    Spacer()
//                    
//                    Text(value.date.formatted(date: .abbreviated, time: .omitted))
//                        .foregroundStyle(.secondary)
//                        .font(.callout)
//                }
//            }
//        }
//        .navigationTitle(item.name)
//        .navigationBarTitleDisplayMode(.inline)
//        .background(Color.systemGroupedBackground)
//        .safeAreaInset(edge: .top) {
//            ZStack {
//                VStack(alignment: .leading) {
//                    VStack(alignment: .leading) {
//                        Label(item.name.uppercased(), systemImage: item.icon)
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                            .foregroundStyle(.secondary)
//                            .labelStyle(SpacingLabelStyle(spacing: 2))
//                            .lineLimit(1)
//                            .minimumScaleFactor(0.5)
//                        
//                        Text(item.value)
//                            .font(.title)
//                            .fontWeight(.semibold)
//                            .foregroundStyle(.primary)
//                            .lineLimit(1)
//                            .minimumScaleFactor(0.5)
//                    }
//                    .getSize { size in
//                        infoHeight = size.height
//                    }
//                    
//                    if let note = item.note {
//                        Text(note)
//                            .font(.footnote)
//                            .foregroundStyle(.secondary)
//                    }
//                    
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
//                
//                if let chartValues {
//                    VStack(spacing: 0) {
//                        Spacer()
//                            .frame(height: infoHeight)
//                            .padding(.bottom)
//                        
//                        LineAndAreaMarkChartView(values: chartValues)
//                    }
//                }
//            }
//            .background(Color.secondarySystemGroupedBackground)
//            .frame(height: 200)
//        }
//        .toolbarBackground(.hidden, for: .navigationBar)
////        .onAppear {
////            let appearance = UINavigationBarAppearance()
////            appearance.shadowColor = .clear
////            
////            navigationItem.standardAppearance = appearance
////            navigationItem.scrollEdgeAppearance = appearance
////            navigationItem.compactAppearance = appearance
////        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        OverviewDetailView(item: .init(type: .mrr, value: ""), chartValues: [])
//    }
//}
//
//struct Stretchy: ViewModifier {
//    var isTop = true
//
//    func heightFor(_ reader: GeometryProxy) -> CGFloat {
//        let height = reader.size.height
//        let frame  = reader.frame(in: .global)
//        let deltaY = isTop ? frame.minY : (UIScreen.main.bounds.size.height - frame.maxY)
//        return height + max(0, deltaY)
//    }
//
//    func offsetFor(_ reader: GeometryProxy) -> CGFloat {
//        guard isTop else { return 0 }
//        let frame  = reader.frame(in: .global)
//        let deltaY = frame.minY
//        return min(0, -deltaY)
//    }
//
//    func body(content: Content) -> some View {
//        GeometryReader { reader in
//            Color.clear
//                .overlay(content.aspectRatio(contentMode: .fill), alignment: .center)
//                .clipped()
//                .frame(height: heightFor(reader))
//                .offset(y: offsetFor(reader))
//        }
//    }
//}
//
//extension View {
//    func stretchy(isTop: Bool = true) -> some View {
//        self.modifier(Stretchy(isTop: isTop))
//    }
//}
