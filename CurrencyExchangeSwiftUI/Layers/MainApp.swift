//
//  CurrencyExchangeSwiftUIApp.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

@main
struct CurrencyExchangeApp: App {
    @StateObject private var router = Router()
    private var dashboardView: DashboardView

    init() {
        Assembly.configureAppState()
        dashboardView = Assembly.createDashboardView()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationContainer(rootView: dashboardView)
            .environmentObject(AppState.shared)
            .environmentObject(router)
        }
    }
}

