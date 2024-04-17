//
//  SettingsView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 2/2/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var pushNotificationsManager: PushNotificationsManager
    
    @State private var showingSupporter = false
    @State private var showingSignOutAlert = false
    
    var body: some View {
        List {
            makeBody()
        }
        .navigationTitle("Settings")
        .navigationDestination(for: String.self) { screen in
            switch screen {
            case "payday":
                PaydayView()
            case "appIcon":
                AppIconView()
                    .environmentObject(purchaseManager)
            case "webhooks":
                WebhooksView()
                    .environmentObject(pushNotificationsManager)
            case "about":
                AboutView()
            case "allWebhooks":
                AllWebhooksView()
            case "webhooksManualSetup":
                WebhooksManualSetupView()
                    .environmentObject(pushNotificationsManager)
            default:
                Text("Unknown destination!")
            }
        }
        .sheet(isPresented: $showingSupporter) {
            NavigationStack {
                SupporterView()
                    .environmentObject(purchaseManager)
            }
        }
        .overlay(content: makeStateView)
        .scrollContentBackground(viewModel.state == .data ? .automatic : .hidden)
        .background(Color.systemGroupedBackground)
        .redacted(reason: viewModel.state == .loading ? .placeholder : [])
        .disabled(viewModel.state == .loading)
        .refreshable {
            await viewModel.refresh()
        }
        .errorAlert(error: $viewModel.errorAlert)
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        if purchaseManager.state == .data {
            if let meSubscription = purchaseManager.meSubscription {
                Section {
                    SettingsSupporterView(
                        title: "You're a \(meSubscription.productType.distinctName)!",
                        subtitle: "Thanks for your support",
                        isActive: false,
                        action: {
                            showingSupporter.toggle()
                        }
                    )
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                .listSectionSpacing(.custom(.zero))
            } else {
                Section {
                    SettingsSupporterView(
                        title: "Become a Supporter!",
                        subtitle: "Support indie development",
                        isActive: true,
                        action: {
                            showingSupporter.toggle()
                        }
                    )
                } footer: {
                    Text("Kedi is a free and [open-source \(Text(imageSystemName: "arrow.up.forward").foregroundStyle(.accent))](https://github.com/sereisoglu/Kedi) RevenueCat client. Kedi was build by a solo [developer \(Text(imageSystemName: "arrow.up.forward").foregroundStyle(.accent))](https://x.com/sereisoglu). If Kedi has made your life easier and you want to support development, you can become a supporter!")
                        .padding(.horizontal)
                }
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
            }
        }
        
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
                value: viewModel.me?.currentPlan?.localizedCapitalized ?? "n/a"
            )
            SettingsAccountItemView(
                key: "This month MTR",
                value: viewModel.me?.billingInfo?.currentMtr?.formatted(.currency(code: "USD").precision(.fractionLength(0))) ?? "n/a"
            )
            SettingsAccountItemView(
                key: "Last 30-day MTR",
                value: viewModel.me?.billingInfo?.trailing30dayMtr?.formatted(.currency(code: "USD").precision(.fractionLength(0))) ?? "n/a"
            )
            SettingsAccountItemView(
                key: "First Transaction Date",
                value: viewModel.me?.firstTransactionAt?.format(to: .iso8601WithoutMilliseconds)?.formatted(date: .abbreviated, time: .shortened) ?? "n/a"
            )
            SettingsAccountItemView(
                key: "Token Expires",
                value: viewModel.authTokenExpiresDate?.formatted(.relative(presentation: .named)).capitalizedSentence ?? "n/a"
            )
        } header: {
            Text("Account")
        }
        
        Section {
            GeneralListView(
                imageAsset: .emoji("🤑"),
                title: "App Store Payday"
            )
            .overlay { NavigationLink(value: "payday") { EmptyView() }.opacity(0) }
        } header: {
            Text("Payday")
        }
        
        Section {
            Toggle(
                "Notifications",
                systemImage: "bell.badge",
                isOn: $pushNotificationsManager.isNotificationsAllowed
            )
            
            GeneralListView(
                imageAsset: .systemImage("link"),
                title: "Webhooks"
            )
            .overlay { NavigationLink(value: "webhooks") { EmptyView() }.opacity(0) }
        } header: {
            Text("Notifications")
        } footer: {
            Text("Add a webhook with **just one tap** to receive notifications of transactions in your projects ✨")
        }
        
        Section {
            GeneralListView(
                imageAsset: .systemImage("app"),
                title: "App Icon"
            )
            .overlay { NavigationLink(value: "appIcon") { EmptyView() }.opacity(0) }
        } header: {
            Text("Customization")
        }
        
        //                Section {
        //                    Button {
        //                        WidgetsManager.shared.reloadAll()
        //                    } label: {
        //                        Text("Force Update")
        //                    }
        //                } header: {
        //                    Text("Widgets")
        //                }
        
        Section {
            Link(destination: URL(string: "https://x.com/kedi_app")!) {
                GeneralListView(
                    imageAsset: .custom("x"),
                    title: "X / Twitter",
                    subtitle: "@kedi_app",
                    accessoryImageSystemName: "arrow.up.right"
                )
            }
            
            Link(destination: URL(string: "mailto:support@kediapp.com")!) {
                GeneralListView(
                    imageAsset: .systemImage("envelope"),
                    title: "Email",
                    subtitle: "support@kediapp.com",
                    accessoryImageSystemName: "arrow.up.right"
                )
            }
            
            Link(destination: URL(string: "https://kediapp.com")!) {
                GeneralListView(
                    imageAsset: .systemImage("globe"),
                    title: "Website",
                    subtitle: "kediapp.com"
                )
            }
            .openUrlInApp()
        } header: {
            Text("Contact")
        }
        
        Section {
            Link(destination: URL(string: "https://kediapp.com/version-history")!) {
                GeneralListView(
                    imageAsset: .systemImage("clock.arrow.circlepath"),
                    title: "What's New!",
                    subtitle: "Show version history"
                )
            }
            .openUrlInApp()
            
            Link(destination: URL(string: "https://apps.apple.com/app/id6478032635?action=write-review")!) {
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
            .overlay { NavigationLink(value: "about") { EmptyView() }.opacity(0) }
        } header: {
            Text("Kedi")
        }
        
        Section {
            Button {
                showingSignOutAlert = true
            } label: {
                Text("Sign Out")
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .confirmationDialog(
                "Sign Out",
                isPresented: $showingSignOutAlert
            ) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) {
                    Task {
                        await viewModel.signOut()
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
        
        Section {
            VStack {
                Text("Version \(Bundle.main.versionNumber ?? "1.0") (\(Bundle.main.buildNumber ?? "1"))")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .listRowBackground(Color.clear)
        }
        .listSectionSpacing(.compact)
    }
    
    @ViewBuilder
    private func makeStateView() -> some View {
        switch viewModel.state {
        case .empty:
            ContentUnavailableView(
                "No Data",
                systemImage: "xmark.circle"
            )
            
        case .error(let error):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(error.localizedDescription)
            )
            
        case .loading,
                .data:
            EmptyView()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(PurchaseManager.shared)
        .environmentObject(PushNotificationsManager.shared)
}
