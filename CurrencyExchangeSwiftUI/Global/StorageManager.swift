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
    private init() { setAppLanguage(to: "ru") }

    func loadCachedData<T: APIModelProtocol>(type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: type.apiType.cacheKey) else { return nil }
        return decodeJSON(type: type, data: data)
    }

    func loadLastFetchTimestamp<T: APIModelProtocol>(type: T.Type) -> Date? {
        return userDefaults.object(forKey: type.apiType.timestampKey) as? Date
    }

    func saveDataToCache<T: APIModelProtocol>(data: T) {
        if let encodedData = encodeJSON(data: data) {
            userDefaults.set(encodedData, forKey: T.apiType.cacheKey)
            userDefaults.set(Date(), forKey: T.apiType.timestampKey)
            print("Cached data saved.")
        }
    }
    
    func setAppLanguage(to language: String) {
        var languageArray = userDefaults.array(forKey: "AppleLanguages") as? [String] ?? []
        
        languageArray[0] = language
        
        userDefaults.set(languageArray, forKey: "AppleLanguages")
        userDefaults.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
    
    
    private func decodeJSON<T: APIModelProtocol>(type: T.Type, data: Data) -> T? {
        return try? JSONDecoder().decode(type, from: data)
    }

    private func encodeJSON<T: APIModelProtocol>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}





