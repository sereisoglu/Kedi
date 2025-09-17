//
//  RequestReviewView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 6/23/24.
//

import SwiftUI

struct RequestReviewView: View {
    
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "star.fill")
                .imageScale(.large)
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Enjoying Kedi?")
                            .fontWeight(.semibold)
                        Spacer()
                        Button(
                            action: {
                                withOptionalAnimation {
                                    userDefaultsManager.isRequestReviewClosed = true
                                }
                            },
                            label: {
                                Image(systemName: "xmark")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                            }
                        )
                        .buttonStyle(.plain)
                    }
                    Text("Rate us on the App Store – it really helps!")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(.trailing)
                
                Divider()
                
                Button(
                    action: {
                        withOptionalAnimation {
                            userDefaultsManager.isRequestReviewClosed = true
                        }
                        BrowserUtility.openAppStoreForReview()
                    },
                    label: {
                        Text("Rate Kedi \(Text(imageSystemName: "arrow.up.forward"))")
                            .fontWeight(.semibold)
                    }
                )
            }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    RequestReviewView()
}
