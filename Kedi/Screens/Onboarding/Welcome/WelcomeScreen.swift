//
//  WelcomeScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/23/24.
//

import SwiftUI

struct WelcomeScreen: View {
    
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    @State private var navigateToFeatures = false
    
    var body: some View {
        VStack(spacing: 10) {
            Image(AppIcon.default.preview)
                .resizable()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 64 * (2 / 9), style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 64 * (2 / 9), style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.2), lineWidth: 0.5)
                )
            
            VStack(spacing: 0) {
                Text("WELCOME TO")
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
                
                Text("Kedi for RevenueCat")
                    .font(.title.bold())
                
                Text("A free and open-source\nRevenueCat client")
                    .font(.body.leading(.tight))
                    .multilineTextAlignment(.center)
            }
            
            ProgressView()
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.systemGroupedBackground)
        .onReceive(timer) { _ in
            navigateToFeatures.toggle()
            timer.upstream.connect().cancel()
        }
        .navigationDestination(isPresented: $navigateToFeatures) {
            FeaturesScreen()
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeScreen()
    }
}
