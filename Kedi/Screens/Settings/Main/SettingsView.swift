//
//  SettingsView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SettingsAccountItemView(
                        key: "Id",
                        value: viewModel.me?.distinctId ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Name",
                        value: viewModel.me?.name ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Email",
                        value: viewModel.me?.email ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Current Plan",
                        value: viewModel.me?.currentPlan?.capitalized ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Current MTR",
                        value: viewModel.me?.billingInfo?.currentMtr?.formatted(.currency(code: "USD").precision(.fractionLength(0))) ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Trailing 30-day MTR",
                        value: viewModel.me?.billingInfo?.trailing30dayMtr?.formatted(.currency(code: "USD").precision(.fractionLength(0))) ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "First Transaction Date",
                        value: viewModel.me?.firstTransactionAt?.format(to: .iso8601WithoutMilliseconds)?.formatted(date: .abbreviated, time: .shortened) ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Token Expires",
                        value: viewModel.authTokenExpiresDate?.relativeFormat(to: .full).capitalized ?? "n/a"
                    )
                } header: {
                    Text("Account")
                }
                
                Section {
                    GeneralListView(
                        imageAsset: .systemImage("app"),
                        title: "App Icon"
                    )
                    .overlay {
                        NavigationLink(value: "appIcon") { EmptyView() }.opacity(0)
                    }
                } header: {
                    Text("Customization")
                }
                
                Section {
                    Link(destination: URL(string: "mailto:sereisoglu@gmail.com")!) {
                        GeneralListView(
                            imageAsset: .systemImage("envelope"),
                            title: "Support",
                            subtitle: "sereisoglu@gmail.com",
                            accessoryImageSystemName: "arrow.up.right"
                        )
                    }
                    
                    Link(destination: URL(string: "https://github.com/sereisoglu/Kedi")!) {
                        GeneralListView(
                            imageAsset: .systemImage("star"),
                            title: "Rate Kedi",
                            subtitle: "Rate us on the App Store – it really helps!",
                            accessoryImageSystemName: "arrow.up.right"
                        )
                    }
                    
                    GeneralListView(
                        imageAsset: .systemImage("info.circle"),
                        title: "About"
                    )
                    .overlay {
                        NavigationLink(value: "about") { EmptyView() }.opacity(0)
                    }
                } header: {
                    Text("Kedi")
                } footer: {
                    Text("Free and [open source](https://github.com/sereisoglu/Kedi) RevenueCat client")
                }
                
                Section {
                    AsyncButton {
                        viewModel.handleSignOutButton()
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Section {
                    Text("Version \(Bundle.main.versionNumber ?? "1.0") (\(Bundle.main.buildNumber ?? "1"))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .listRowBackground(Color.clear)
                }
                .listSectionSpacing(.compact)
            }
            .navigationTitle("Settings")
            .navigationDestination(for: String.self) { screen in
                switch screen {
                case "appIcon":
                    AppIconView()
                case "about":
                    AboutView()
                default:
                    Text("Unknown destination!")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
