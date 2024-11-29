//
//  StorageManager.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

protocol StorageManagerProtocol {
    func loadCachedData<T: APIModelProtocol>(type: T.Type) -> T?
    func loadLastFetchTimestamp<T: APIModelProtocol>(type: T.Type) -> Date?
    func saveDataToCache<T: APIModelProtocol>(data: T)
}

struct StorageManager: StorageManagerProtocol {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    private init() { }

    func loadCachedData<T: APIModelProtocol>(type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: type.apiType.cacheKey) else { return nil }
        let decoded = decodeJSON(type: type, data: data)
        return decoded
    }

    func loadLastFetchTimestamp<T: APIModelProtocol>(type: T.Type) -> Date? {
        return userDefaults.object(forKey: type.apiType.timestampKey) as? Date
    }

    func saveDataToCache<T: APIModelProtocol>(data: T) {
        if let encodedData = encodeJSON(data: data) {
            userDefaults.set(encodedData, forKey: T.apiType.cacheKey)
            userDefaults.set(Date(), forKey: T.apiType.timestampKey)
        }
    }
    
    func saveAppTheme(to theme: Constants.Theme) {
        if let encoded = try? JSONEncoder().encode(theme) {
            userDefaults.set(encoded, forKey: Constants.Theme.cacheKey)
        }
    }
    
    func loadAppTheme() -> Constants.Theme? {
        guard let data = userDefaults.data(forKey: Constants.Theme.cacheKey) else { return nil }
        if let decoded = try? JSONDecoder().decode(Constants.Theme.self, from: data) {
            return decoded
        }
        
        return nil
    }
    
    func saveAppLanguage(to language: Constants.Language) {
        if let encoded = try? JSONEncoder().encode(language) {
            userDefaults.set(encoded, forKey: Constants.Language.cacheKey)
        }
    }
    
    func loadAppLanguage() -> Constants.Language? {
        guard let data = userDefaults.data(forKey: Constants.Language.cacheKey) else { return nil }
        if let decoded = try? JSONDecoder().decode(Constants.Language.self, from: data) {
            return decoded
        }
        
        return nil
    }
    
    
    private func decodeJSON<T: APIModelProtocol>(type: T.Type, data: Data) -> T? {
        return try? JSONDecoder().decode(type, from: data)
    }

    private func encodeJSON<T: APIModelProtocol>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}





