//
//  AppState.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 05.12.2024.
//

import Foundation

class AppState: ObservableObject {
    static let shared: AppState = AppState()
    private init() {}
    
    @Published var selectedCity: Constants.City = Constants.City.tbilisi
    @Published var selectedCurrencies: [Constants.CurrencyType] = [Constants.CurrencyType.gel, Constants.CurrencyType.usd]
    @Published var includeOnline = false
    @Published var workingNow = false
    
    @Published var theme: Constants.Theme = StorageManager.shared.loadAppTheme() ?? .light
    @Published var language: Constants.Language = StorageManager.shared.loadAppLanguage() ?? Constants.Language.defaultLanguage
    
    // MARK: - Theme
    func setTheme(_ newTheme: Constants.Theme) {
        theme = newTheme
        StorageManager.shared.saveAppTheme(to: theme)
        print("Set theme: \(newTheme)")
    }
    
    func toggleTheme() {
        setTheme(theme == .dark ? .light : .dark)
    }
}
