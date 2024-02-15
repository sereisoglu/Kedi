//
//  AboutView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/14/24.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .center) {
                    Image(uiImage: AppIcon.default.uiImage)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 120 * (2 / 9), style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 120 * (2 / 9), style: .continuous)
                                .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                    
                    Text("Kedi")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Version \(Bundle.main.versionNumber ?? "1.0") (\(Bundle.main.buildNumber ?? "1"))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    
                    Text("Free and [open source](https://github.com/sereisoglu/Kedi) RevenueCat client")
                    
                    Text("Kedi is a Turkish word meaning cat.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .frame(maxWidth: .infinity)
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
            }
            
            Section {
                Link(destination: URL(string: "https://x.com/sereisoglu")!) {
                    GeneralListView(
                        imageAsset: .custom("x"),
                        title: "Saffet Emin Reisoğlu",
                        subtitle: "@sereisoglu",
                        accessoryImageSystemName: "arrow.up.right"
                    )
                }
            } header: {
                Text("Designed and developed by")
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/twitter/twemoji")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "Twemoji",
                        accessoryImageSystemName: "arrow.up.right"
                    )
                }
            } header: {
                Text("Resources")
            } footer: {
                Text("Twemoji was used when designing the app icon.")
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/sereisoglu/Kedi")!) {
                    GeneralListView(
                        imageAsset: .systemImage("hand.raised"),
                        title: "Privacy Policy",
                        accessoryImageSystemName: "arrow.up.right"
                    )
                }
                
                Link(destination: URL(string: "https://github.com/sereisoglu/Kedi")!) {
                    GeneralListView(
                        imageAsset: .systemImage("doc.text"),
                        title: "Terms & Conditions",
                        accessoryImageSystemName: "arrow.up.right"
                    )
                }
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView()
}

