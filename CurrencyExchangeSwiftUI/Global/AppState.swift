//
//  AppState.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 05.12.2024.
//

import Foundation

class AppState: ObservableObject {
    static private(set) var shared: AppState!
    let store: StorageManagerProtocol
    
    @Published var selectedCity: Constants.City
    @Published var selectedCurrencies: [Constants.CurrencyType]
    @Published var includeOnline: Bool
    @Published var workingAvailability: Constants.Options.Availability
    @Published var theme: Constants.Theme
    @Published var language: Constants.Language
    
    private init(store: StorageManagerProtocol) {
        self.store = store
        self.selectedCity = store.loadCity() ?? Constants.City.tbilisi
        self.selectedCurrencies = store.loadSelectedCurrencies() ?? [Constants.CurrencyType.gel, Constants.CurrencyType.usd]
        self.includeOnline = store.loadIncludeOnline() ?? false
        self.workingAvailability = store.loadWokingAvailability() ?? Constants.Options.Availability.all
        self.theme = store.loadAppTheme() ?? .light
        self.language =  store.loadAppLanguage() ?? Constants.Language.en
    }

    static func configure(store: StorageManagerProtocol) {
        shared = AppState(store: store)
    }
    
    // MARK: - Options
    func setSelectedCurrencies(_ newValue: [Constants.CurrencyType]) {
        selectedCurrencies = newValue
        store.saveSelectedCurrencies(currencies: newValue)
        print("Set selected currncies: \(newValue.count)")
    }
    
    func setCity(_ newCity: Constants.City) {
        if selectedCity == newCity { return }
        selectedCity = newCity
        store.saveCity(city: newCity)
        print("Set city: \(newCity)")
    }

    func setWorkingAvailability(availability: Constants.Options.Availability) {
        workingAvailability = availability
        store.saveWokingAvailability(working: availability)
        print("Set working now: \(availability)")
    }
    
    func toggleIncludeOnline() {
        includeOnline.toggle()
        store.saveIncludeOnline(include: includeOnline)
        print("Set include online: \(includeOnline)")
    }
    
    // MARK: - Theme
    func toggleTheme() {
        let newTheme: Constants.Theme = theme == .dark ? .light : .dark
        theme = newTheme
        store.saveAppTheme(to: theme)
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
        store.saveAppLanguage(to: newLang)
        print("Set language to: \(newLang.rawValue)")
    }
}

func translated(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, bundle: AppState.shared.bundle, comment: comment)
}

