//
//  AboutScreen.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/14/24.
//

import SwiftUI

struct AboutScreen: View {
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 0) {
                    Image(AppIcon.default.preview)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 120 * (2 / 9), style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 120 * (2 / 9), style: .continuous)
                                .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.bottom, 8)
                    
                    Text("Kedi for RevenueCat")
                        .font(.title.bold())
                        .padding(.bottom, 2)
                    
                    Text("A free and [open-source \(Text(imageSystemName: "arrow.up.forward").foregroundStyle(.accent))](https://github.com/sereisoglu/Kedi) RevenueCat client")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 2)
                    
                    Text("Version \(Bundle.main.versionNumber ?? "1.0") (\(Bundle.main.buildNumber ?? "1"))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                    
                    Text("Designed and developed by [Saffet Emin Reisoğlu](https://x.com/sereisoglu) in Trabzon, Turkey.")
                        .multilineTextAlignment(.center)
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
                        subtitle: "It was used when designing the app icon.\nCopyright (c) 2021 Twitter"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/Alamofire/Alamofire/blob/master/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "Alamofire",
                        subtitle: "Copyright (c) 2014 Alamofire Software Foundation"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/hyperoslo/Cache/blob/master/LICENSE.md")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "Cache",
                        subtitle: "Copyright (c) 2015 Hyper Interaktiv AS"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/evgenyneu/keychain-swift/blob/master/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "KeychainSwift",
                        subtitle: "Copyright (c) 2015 Evgenii Neumerzhitckii"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/OneSignal/OneSignal-XCFramework/blob/main/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "OneSignal-XCFramework",
                        subtitle: "Copyright (c) 2020 OneSignal"
                    )
                }
                .openUrlInApp()
                
                Link(destination: URL(string: "https://github.com/RevenueCat/purchases-ios/blob/main/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "RevenueCat",
                        subtitle: "Copyright (c) 2017 Jacob Eiting"
                    )
                }
                
                Link(destination: URL(string: "https://github.com/TelemetryDeck/SwiftClient/blob/main/LICENSE")!) {
                    GeneralListView(
                        imageAsset: .custom("github"),
                        title: "TelemetryClient",
                        subtitle: "Copyright (c) 2020 Daniel Jilg"
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
    AboutScreen()
}

