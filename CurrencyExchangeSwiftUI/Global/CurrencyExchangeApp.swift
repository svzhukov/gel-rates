//
//  CurrencyExchangeSwiftUIApp.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

@main
struct CurrencyExchangeApp: App {
    @State private var refreshID = UUID()

    var body: some Scene {
        WindowGroup {
            AppAssembly.createDashboardView()
                .id(refreshID)
                .onReceive(NotificationCenter.default.publisher(for: .languageDidChange)) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        refreshID = UUID()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .languageDidSetup)) { _ in
                    refreshID = UUID()
                }
                .onAppear {
                    Localization.initialize()
                }
        }
    }
}
