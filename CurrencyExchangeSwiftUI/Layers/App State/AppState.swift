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
    let liveService: LiveExchangeRateServiceProtocol
    let prefService: PreferencesServiceProtocol
    
    @Published var selectedCity: Constants.City
    @Published var selectedCurrencies: [Constants.CurrencyType]
    @Published var includeOnline: Bool
    @Published var workingAvailability: Constants.Options.Availability
    @Published var theme: Constants.Theme
    @Published var language: Constants.Language
    
    private init(store: StorageManagerProtocol, liveService: LiveExchangeRateServiceProtocol, prefService: PreferencesServiceProtocol) {
        self.store = store
        self.liveService = liveService
        self.prefService = prefService

        self.selectedCity = liveService.loadCity() ?? Constants.City.tbilisi
        self.selectedCurrencies = liveService.loadSelectedCurrencies() ?? Constants.CurrencyType.allCases
        self.includeOnline = liveService.loadIncludeOnline() ?? false
        self.workingAvailability = liveService.loadWokingAvailability() ?? Constants.Options.Availability.all
        self.theme = prefService.loadAppTheme() ?? .light
        self.language =  prefService.loadAppLanguage() ?? Constants.Language.en
    }

    static func configure(store: StorageManagerProtocol, liveService: LiveExchangeRateServiceProtocol, prefService: PreferencesServiceProtocol) {
        shared = AppState(store: store, liveService: liveService, prefService: prefService)
    }
    
    // MARK: - Options
    func setSelectedCurrencies(_ newValue: [Constants.CurrencyType]) {
        selectedCurrencies = newValue
        liveService.saveSelectedCurrencies(currencies: newValue)
        print("Set selected currncies: \(newValue.count)")
    }
    
    func setCity(_ newCity: Constants.City) {
        if selectedCity == newCity { return }
        selectedCity = newCity
        liveService.saveCity(city: newCity)
        print("Set city: \(newCity)")
    }

    func setWorkingAvailability(availability: Constants.Options.Availability) {
        workingAvailability = availability
        liveService.saveWokingAvailability(working: availability)
        print("Set working now: \(availability)")
    }
    
    func toggleIncludeOnline() {
        includeOnline.toggle()
        liveService.saveIncludeOnline(include: includeOnline)
        print("Set include online: \(includeOnline)")
    }
    
    // MARK: - Theme
    func toggleTheme() {
        let newTheme: Constants.Theme = theme == .dark ? .light : .dark
        theme = newTheme
        prefService.saveAppTheme(to: theme)
        print("Set theme: \(newTheme)")
    }

    // MARK: - Language
    func setLanguage(_ newLang: Constants.Language) {
        if language == newLang { return }
        language = newLang
        prefService.saveAppLanguage(to: newLang)
        print("Set language to: \(newLang.rawValue)")
    }
}
