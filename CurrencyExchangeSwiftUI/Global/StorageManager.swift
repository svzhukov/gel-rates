//
//  StorageManager.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

protocol StorageManagerProtocol {
    func loadJSONModel<T: JSONModelProtocol>(type: T.Type) -> T?
    func loadLastFetchTimestamp<T: JSONModelProtocol>(type: T.Type) -> Date?
    func saveJSONModel<T: JSONModelProtocol>(data: T)
    
    func saveAppTheme(to theme: Constants.Theme)
    func loadAppTheme() -> Constants.Theme?
    
    func saveAppLanguage(to language: Constants.Language)
    func loadAppLanguage() -> Constants.Language?
    
    func saveSelectedCurrencies(currencies: [Constants.CurrencyType])
    func loadSelectedCurrencies() -> [Constants.CurrencyType]?
    
    func saveCity(city: Constants.City)
    func loadCity() -> Constants.City?
    
    func saveIncludeOnline(include: Bool)
    func loadIncludeOnline() -> Bool?
    
    func saveWokingAvailability(working: Constants.Options.Availability)
    func loadWokingAvailability() -> Constants.Options.Availability?
}

class StorageManager: StorageManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private var inMemoryData: [String: Any] = [:]

    // MARK: - JSON Models
    func loadJSONModel<T: JSONModelProtocol>(type: T.Type) -> T? {
        if let data = load(type, forKey: type.apiType.cacheKey) as? T {
            return data
        }
        return nil
    }

    func loadLastFetchTimestamp<T: JSONModelProtocol>(type: T.Type) -> Date? {
        if let timestamp = load(Date.self, forKey: type.apiType.timestampKey) as? Date {
            return timestamp
        }
        return nil
    }

    func saveJSONModel<T: JSONModelProtocol>(data: T) {
        save(data, forKey: T.apiType.cacheKey)
        saveJSONModelTimestamp(data: data)
    }
    
    func saveJSONModelTimestamp<T: JSONModelProtocol>(data: T) {
        save(Date(), forKey: T.apiType.timestampKey)
    }
    
    // MARK: - Theme
    func saveAppTheme(to theme: Constants.Theme) {
        save(theme, forKey: Constants.Theme.cacheKey)
    }
    
    func loadAppTheme() -> Constants.Theme? {
        if let theme = load(Constants.Theme.self, forKey: Constants.Theme.cacheKey) as? Constants.Theme {
            return theme
        }
        return nil
    }
    
    // MARK: - Language
    func saveAppLanguage(to language: Constants.Language) {
        save(language, forKey: Constants.Language.cacheKey)
    }
    
    func loadAppLanguage() -> Constants.Language? {
        if let language = load(Constants.Language.self, forKey: Constants.Language.cacheKey) as? Constants.Language {
            return language
        }
        return nil
    }
    
    // MARK: - Currencies
    func saveSelectedCurrencies(currencies: [Constants.CurrencyType]) {
        save(currencies, forKey: Constants.CurrencyType.cacheKey)
    }
    
    func loadSelectedCurrencies() -> [Constants.CurrencyType]? {
        if let currencies = load([Constants.CurrencyType].self, forKey: Constants.CurrencyType.cacheKey) as? [Constants.CurrencyType] {
            return currencies
        }
        return nil
    }
    
    // MARK: - Options
    func saveCity(city: Constants.City) {
        save(city, forKey: Constants.City.cacheKey)
    }
    
    func loadCity() -> Constants.City? {
        if let city = load(Constants.City.self, forKey: Constants.City.cacheKey) as? Constants.City {
            return city
        }
        return nil
    }
    
    func saveIncludeOnline(include: Bool) {
        save(include, forKey: Constants.Options.includeOnline.cacheKey)
    }
    
    func loadIncludeOnline() -> Bool? {
        if let include = load(Bool.self, forKey: Constants.Options.includeOnline.cacheKey) as? Bool{
            return include
        }
        return nil
    }
    
    func saveWokingAvailability(working: Constants.Options.Availability) {
        save(working, forKey: Constants.Options.Availability.cacheKey)
    }
    
    func loadWokingAvailability() -> Constants.Options.Availability? {
        if let working = load(Constants.Options.Availability.self, forKey: Constants.Options.Availability.cacheKey) as? Constants.Options.Availability {
            return working
        }
        return nil
    }
    
    // MARK: - Private
    private func save(_ obj: Encodable, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(obj) {
            userDefaults.set(encoded, forKey: key)
            inMemoryData[key] = obj
        }
    }
    
    private func load<T: Decodable>(_ type: T.Type, forKey key: String) -> (any Decodable)? {
        if let inMemory = inMemoryData[key] as? Decodable { return inMemory }
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            let decoded = try JSONDecoder().decode(type, from: data)
            inMemoryData[key] = decoded
            return decoded
        } catch {
            print(error)
        }
 
        return nil
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, data: Data) -> T? {
        return try? JSONDecoder().decode(type, from: data)
    }

    private func encodeJSON<T: Encodable>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}





