//
//  StorageManager.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

protocol StorageManagerProtocol {
    func loadCachedData<T: JSONModelProtocol>(type: T.Type) -> T?
    func loadLastFetchTimestamp<T: JSONModelProtocol>(type: T.Type) -> Date?
    func saveDataToCache<T: JSONModelProtocol>(data: T)
}

class StorageManager: StorageManagerProtocol {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    private var inMemoryData: [String: Any] = [:]

    private init() { }

    func loadCachedData<T: JSONModelProtocol>(type: T.Type) -> T? {
        if let inMemory = inMemoryData[type.apiType.cacheKey] as? T { return inMemory }
        guard let data = userDefaults.data(forKey: type.apiType.cacheKey) else { return nil }
        let decoded = decodeJSON(type: type, data: data)
        inMemoryData[type.apiType.cacheKey] = decoded
        
        return decoded
    }

    func loadLastFetchTimestamp<T: JSONModelProtocol>(type: T.Type) -> Date? {
        if let inMemory = inMemoryData[type.apiType.timestampKey] as? Date { return inMemory }
        let timestamp = userDefaults.object(forKey: type.apiType.timestampKey) as? Date
        inMemoryData[type.apiType.timestampKey] = timestamp
        
        return timestamp
    }

    func saveDataToCache<T: JSONModelProtocol>(data: T) {
        if let encodedData = encodeJSON(data: data) {
            userDefaults.set(encodedData, forKey: T.apiType.cacheKey)
            inMemoryData[T.apiType.cacheKey] = data

            userDefaults.set(Date(), forKey: T.apiType.timestampKey)
            inMemoryData[T.apiType.timestampKey] = Date()
        }
    }
    
    func saveAppTheme(to theme: Appearance.Theme) {
        if let encoded = try? JSONEncoder().encode(theme) {
            userDefaults.set(encoded, forKey: Constants.themeCacheKey)
            inMemoryData[Constants.themeCacheKey] = theme
        }
    }
    
    func loadAppTheme() -> Appearance.Theme? {
        if let inMemory = inMemoryData[Constants.themeCacheKey] as? Appearance.Theme { return inMemory }
        guard let data = userDefaults.data(forKey: Constants.themeCacheKey) else { return nil }
        if let decoded = try? JSONDecoder().decode(Appearance.Theme.self, from: data) {
            inMemoryData[Constants.themeCacheKey] = decoded
            return decoded
        }
        
        return nil
    }
    
    func saveAppLanguage(to language: Constants.Language) {
        if let encoded = try? JSONEncoder().encode(language) {
            userDefaults.set(encoded, forKey: Constants.Language.cacheKey)
            inMemoryData[Constants.Language.cacheKey] = language
        }
    }
    
    func loadAppLanguage() -> Constants.Language? {
        if let inMemory = inMemoryData[Constants.Language.cacheKey] as? Constants.Language { return inMemory }
        guard let data = userDefaults.data(forKey: Constants.Language.cacheKey) else { return nil }
        if let decoded = try? JSONDecoder().decode(Constants.Language.self, from: data) {
            inMemoryData[Constants.Language.cacheKey] = decoded
            return decoded
        }
        
        return nil
    }
    
    
    private func decodeJSON<T: JSONModelProtocol>(type: T.Type, data: Data) -> T? {
        return try? JSONDecoder().decode(type, from: data)
    }

    private func encodeJSON<T: JSONModelProtocol>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}





