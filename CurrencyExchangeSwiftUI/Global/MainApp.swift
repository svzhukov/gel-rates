//
//  CurrencyExchangeSwiftUIApp.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

@main
struct CurrencyExchangeApp: App {
    init() {
        Assembly.configureAppState()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Assembly.createDashboardView()
                    .navigationBarHidden(true)
            }
            .environmentObject(AppState.shared)
        }

    }
}

