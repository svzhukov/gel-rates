//
//  StorageManager.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

protocol StorageManagerProtocol {
    func saveData(_ data: Data, key: String)
    func fetchData(key: String) -> Data?
}

class StorageManager: StorageManagerProtocol {
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func saveData(_ data: Data, key: String) {
        userDefaults.set(data, forKey: key)
    }
    
    func fetchData(key: String) -> Data? {
        userDefaults.data(forKey: key)
    }
}





