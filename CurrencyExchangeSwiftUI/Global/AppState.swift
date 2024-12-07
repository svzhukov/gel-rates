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
    
    @Published var selectedCity: Constants.City = StorageManager.shared.loadCity() ?? Constants.City.tbilisi
    @Published var selectedCurrencies: [Constants.CurrencyType] = StorageManager.shared.loadSelectedCurrencies() ?? [Constants.CurrencyType.gel, Constants.CurrencyType.usd]
    @Published var includeOnline = StorageManager.shared.loadIncludeOnline() ?? false
    @Published var workingAvailability = StorageManager.shared.loadWokingAvailability() ?? Constants.Options.Availability.all
    @Published var theme: Constants.Theme = StorageManager.shared.loadAppTheme() ?? .light
    @Published var language: Constants.Language = StorageManager.shared.loadAppLanguage() ?? Constants.Language.en
    
    // MARK: - Options
    func setSelectedCurrencies(_ newValue: [Constants.CurrencyType]) {
        selectedCurrencies = newValue
        StorageManager.shared.saveSelectedCurrencies(currencies: newValue)
        print("Set selected currncies: \(newValue)")
    }
    
    func setCity(_ newCity: Constants.City) {
        if selectedCity == newCity { return }
        selectedCity = newCity
        StorageManager.shared.saveCity(city: newCity)
        print("Set city: \(newCity)")
    }

    func setWorkingAvailability(availability: Constants.Options.Availability) {
        workingAvailability = availability
        StorageManager.shared.saveWokingAvailability(working: availability)
        print("Set working now: \(availability)")
    }
    
    func toggleIncludeOnline() {
        includeOnline.toggle()
        StorageManager.shared.saveIncludeOnline(include: includeOnline)
        print("Set include online: \(includeOnline)")
    }
    
    // MARK: - Theme
    func toggleTheme() {
        let newTheme: Constants.Theme = theme == .dark ? .light : .dark
        theme = newTheme
        StorageManager.shared.saveAppTheme(to: theme)
        print("Set theme: \(newTheme)")
    }

    // MARK: - Localization
    var bundle: Bundle {
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        } else {
            return .main
        }
    }

    func setLanguage(_ newLang: Constants.Language) {
        if language == newLang { return }
        language = newLang
        StorageManager.shared.saveAppLanguage(to: newLang)
        print("Set language to: \(newLang.rawValue)")
    }
}

func translated(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, bundle: AppState.shared.bundle, comment: comment)
}

