//
//  View+Extension.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/13/24.
//

import SwiftUI

// MARK: - getSize

// https://www.youtube.com/watch?v=H6S5xKgb9k8
extension View {
    
    func getSize(size: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear.preference(key: ViewPreferenceKey.self, value: geo.size)
            }
        )
        .onPreferenceChange(ViewPreferenceKey.self, perform: size)
    }
}

private struct ViewPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

// MARK: - refreshableWithoutCancellation
// https://stackoverflow.com/a/76305308/9212388

extension View {
    
    nonisolated func refreshableWithoutCancellation(action: @escaping @Sendable () async -> Void) -> some View {
        refreshable { await Task { await action() }.value }
    }
}

// MARK: - iOS 26

extension View {
    
    @ViewBuilder
    func safeAreaBar_iOS26<V>(edge: VerticalEdge, @ViewBuilder content: () -> V) -> some View where V : View {
        if #available(iOS 26, *) {
            safeAreaBar(edge: edge, spacing: 0, content: content)
        } else {
            safeAreaInset(edge: edge, spacing: 0, content: content)
                .background(.ultraThinMaterial)
                .overlay(Rectangle().frame(height: 1, alignment: .top).foregroundStyle(.primary.opacity(0.2)), alignment: .top)
        }
    }
}

// MARK: - iOS 18

extension View {
    
    @ViewBuilder
    func matchedTransitionSource_iOS18(
        id: (some Hashable)?,
        in namespace: Namespace.ID?
    ) -> some View {
        if #available(iOS 18, *), let namespace {
            matchedTransitionSource(id: id, in: namespace)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func navigationTransitionZoom_iOS18(
        sourceID: (some Hashable)?,
        in namespace: Namespace.ID?
    ) -> some View {
        if #available(iOS 18, *), let namespace {
            navigationTransition(.zoom(sourceID: sourceID, in: namespace))
        } else {
            self
        }
    }
}
