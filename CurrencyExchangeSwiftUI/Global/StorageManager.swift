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
}

class StorageManager: StorageManagerProtocol {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    private var inMemoryData: [String: Any] = [:]

    private init() { }

    
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
    func saveAppTheme(to theme: Appearance.Theme) {
        save(theme, forKey: Constants.themeCacheKey)
    }
    
    func loadAppTheme() -> Appearance.Theme? {
        if let theme = load(Appearance.Theme.self, forKey: Constants.themeCacheKey) as? Appearance.Theme {
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
    
    // MARK: - City
    func saveCity(city: Constants.City) {
        save(city, forKey: Constants.City.cacheKey)
    }
    
    func loadCity() -> Constants.City? {
        if let city = load(Constants.City.self, forKey: Constants.City.cacheKey) as? Constants.City {
            return city
        }
        return nil
    }
    
    // MARK: - Currencies
//    func saveSelectedCurrencies(currencies: [Currency.CurrencyType]) {
//        save(currencies, forKey: Constants.City.cacheKey)
//    }
//    
//    func loadCity() -> Constants.City? {
//        if let city = load(Constants.City.self, forKey: Constants.City.cacheKey) as? Constants.City {
//            return city
//        }
//        return nil
//    }
    
    // MARK: - Private
    private func save(_ obj: Encodable, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(obj) {
            print("user defaults saved: \(key)")
            userDefaults.set(encoded, forKey: key)
            inMemoryData[key] = obj
        }
    }
    
    private func load<T: Decodable>(_ type: T.Type, forKey key: String) -> (any Decodable)? {
        if let inMemory = inMemoryData[key] as? Decodable { return inMemory }
        guard let data = userDefaults.data(forKey: key) else { return nil }
        if let decoded = try? JSONDecoder().decode(type, from: data) {
            print("user defaults loaded: \(key)")
            inMemoryData[key] = decoded
            return decoded
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





