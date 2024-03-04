//
//  OverviewDropDelegate.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/3/24.
//

import SwiftUI

struct OverviewDropDelegate: DropDelegate {
    
    let viewModel: OverviewViewModel
    let item: OverviewItem
    @Binding var draggingItem: OverviewItem?
    
    func dropEntered(info: DropInfo) {
        if draggingItem == nil {
            draggingItem = item
        }
        
        withAnimation(.bouncy) {
            viewModel.moveItem(source: draggingItem!, target: item)
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        .init(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        withAnimation(.bouncy) {
            draggingItem = nil
        }
        return true
    }
}
