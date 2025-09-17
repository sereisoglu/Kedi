//
//  NotificationsPermissionScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/23/24.
//

import SwiftUI

struct NotificationsPermissionScreen: View {
    
    @EnvironmentObject var pushNotificationsManager: PushNotificationsManager
    
    @State private var isImageHidden = false
    @State private var imageHeight: CGFloat = .zero
    @State private var margin: CGFloat = .zero
    
    var body: some View {
        VStack(spacing: 20) {
            if !isImageHidden {
                Rectangle()
                    .fill(Color.systemGroupedBackground)
                    .frame(maxWidth: 750)
                    .overlay {
                        Image(.Images.onboarding2)
                            .resizable()
                            .scaledToFill()
                            .frame(height: imageHeight, alignment: .top)
                    }
                    .clipped()
                    .getSize { size in
                        imageHeight = size.height
                    }
                    .padding(.horizontal)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text("Notifications")
                        .font(.largeTitle.bold())
                    
                    Text("Allow notifications for subscription and purchase events, App Store payday, and more.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 10) {
                    Button {
                        pushNotificationsManager.togglePermissionStatus { _ in
                            withAnimation {
                                pushNotificationsManager.isPermissionOpened = true
                            }
                        }
                    } label: {
                        Text("Allow")
                            .font(.body.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    
                    Text("You can configure it at any time from the settings.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, margin > 0 ? margin : 16)
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.systemGroupedBackground)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        pushNotificationsManager.isPermissionOpened = true
                    }
                } label: {
                    Text("Skip")
                }
            }
        }
        .getSize { size in
            let width = min(size.width, 500)
            margin = (size.width - width) / 2
            isImageHidden = size.height < 500
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsPermissionScreen()
    }
}
