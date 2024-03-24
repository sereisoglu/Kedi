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
                    
                    Text("A free and [open-source \(Text(imageSystemName: "arrow.up.forward").foregroundStyle(.accent))](https://github.com/sereisoglu/Kedi) RevenueCat client")
                }
                .frame(maxWidth: .infinity)
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
            }
            
            Section {
                Text("Kedi is a Turkish word meaning cat.")
            } header: {
                Text("What does Kedi mean?")
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
                Link(destination: URL(string: "https://kediapp.com/privacy-policy")!) {
                    GeneralListView(
                        imageAsset: .systemImage("hand.raised"),
                        title: "Privacy Policy"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://kediapp.com/terms-and-conditions")!) {
                    GeneralListView(
                        imageAsset: .systemImage("doc.text"),
                        title: "Terms & Conditions"
                    )
                }
                .openUrlInApp()
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/twitter/twemoji/blob/master/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "Twemoji",
                        subtitle: "Copyright 2021 Twitter\nIt was used when designing the app icon."
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/Alamofire/Alamofire/blob/master/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "Alamofire",
                        subtitle: "Copyright 2014 Alamofire Software Foundation"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/hyperoslo/Cache/blob/master/LICENSE.md")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "Cache",
                        subtitle: "Copyright 2015 Hyper Interaktiv AS"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/evgenyneu/keychain-swift/blob/master/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "KeychainSwift",
                        subtitle: "Copyright 2015 Evgenii Neumerzhitckii"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/OneSignal/OneSignal-XCFramework/blob/main/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "OneSignal-XCFramework",
                        subtitle: "Copyright 2020 OneSignal"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/RevenueCat/purchases-ios/blob/main/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "RevenueCat",
                        subtitle: "Copyright 2017 Jacob Eiting"
                    )
                }
            } header: {
                Text("Acknowledgments")
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView()
}

