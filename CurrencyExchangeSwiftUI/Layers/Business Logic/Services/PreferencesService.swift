//
//  SettingsService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 12.12.2024.
//

import Foundation

protocol PreferencesServiceProtocol {
    func saveAppTheme(to theme: Constants.Theme)
    func loadAppTheme() -> Constants.Theme?
    
    func saveAppLanguage(to language: Constants.Language)
    func loadAppLanguage() -> Constants.Language?
}

class PreferencesService: BaseService, PreferencesServiceProtocol {
    // MARK: - Theme
    func saveAppTheme(to theme: Constants.Theme) {
        save(theme, key: Constants.Theme.cacheKey)
    }
    
    func loadAppTheme() -> Constants.Theme? {
        if let theme = load(Constants.Theme.self, key: Constants.Theme.cacheKey) as? Constants.Theme {
            return theme
        }
        return nil
    }
    
    // MARK: - Language
    func saveAppLanguage(to language: Constants.Language) {
        save(language, key: Constants.Language.cacheKey)
    }
    
    func loadAppLanguage() -> Constants.Language? {
        if let language = load(Constants.Language.self, key: Constants.Language.cacheKey) as? Constants.Language {
            return language
        }
        return nil
    }
    
    // MARK: - Private
}
