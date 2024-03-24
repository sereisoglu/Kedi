//
//  NotificationsView.swift
//  Kedi
//
//  Created by Saffet Emin Reisoğlu on 3/24/24.
//

import SwiftUI

struct NotificationsView: View {
    
    @StateObject private var viewModel = NotificationsViewModel()
    @EnvironmentObject var pushNotificationsManager: PushNotificationsManager
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle("Notifications")
    }
}

#Preview {
    NotificationsView()
}
