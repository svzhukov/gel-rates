//
//  BaseExchangeRateService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 12.12.2024.
//

import Foundation

class BaseService {
    let store: StorageManagerProtocol
    
    var inMemoryCache: [String : Any] = [:]
    var isFetching: Bool = false
    
    init(store: StorageManagerProtocol) {
        self.store = store
    }
    
    func save(_ obj: Encodable, key: String) {
        guard let data = encodeJSON(data: obj) else { return }
        store.saveData(data, key: key)
        inMemoryCache[key] = obj
    }

    func load<T: Decodable>(_ type: T.Type, key: String) -> (any Decodable)? {
        if let inMemory = inMemoryCache[key] as? T { return inMemory }
        guard let data = store.fetchData(key: key) else { return nil }

        let decoded = decodeJSON(type: type, data: data)
        inMemoryCache[key] = decoded
        return decoded
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, data: Data) -> T? {
        return try? JSONDecoder().decode(type, from: data)
    }

    private func encodeJSON<T: Encodable>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
    
    func shouldReuseCachedData(key: String) -> Bool {
        guard let lastFetch = load(Date.self, key: key) as? Date else { return false }
        return Date().timeIntervalSince(lastFetch) < Constants.delayBeforeNewAPIRequest
    }
}
