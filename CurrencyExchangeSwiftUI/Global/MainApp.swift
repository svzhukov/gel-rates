//
//  CurrencyExchangeSwiftUIApp.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

@main
struct CurrencyExchangeApp: App {
    @ObservedObject private var state = AppState.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    Assembly.createDashboardView()
                }
            }
            .preferredColorScheme(state.theme.colorSceme)
        }
    }
}
