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
                        value: viewModel.me?.currentPlan ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Current MTR",
                        value: viewModel.me?.billingInfo?.currentMtr?.formatted(.currency(code: "USD")) ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Trailing 30-day MTR",
                        value: viewModel.me?.billingInfo?.trailing30dayMtr?.formatted(.currency(code: "USD")) ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "First Transaction Date",
                        value: viewModel.me?.firstTransactionAt?.format(to: .iso8601WithoutMilliseconds)?.formatted(date: .abbreviated, time: .shortened) ?? "n/a"
                    )
                    SettingsAccountItemView(
                        key: "Token Expires",
                        value: viewModel.authTokenExpiresDate?.relativeFormat(to: .full) ?? "n/a"
                    )
                } header: {
                    Text("Account")
                }
                
                AsyncButton {
                    viewModel.handleSignOutButton()
                } label: {
                    Text("Sign Out")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
