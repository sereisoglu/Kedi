//
//  PageControl.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/23/24.
//

import UIKit
import SwiftUI

struct PageControl: UIViewRepresentable {
    
    @Binding var currentPage: Int
    @Binding var numberOfPages: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let uiView = UIPageControl()
        //        uiView.backgroundStyle = .prominent
        uiView.currentPageIndicatorTintColor = .label
        uiView.pageIndicatorTintColor = .tertiaryLabel
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
        return uiView
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }
}
