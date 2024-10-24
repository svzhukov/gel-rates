//
//  JSONWrapper.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.10.2024.
//

import Foundation

struct JsonWrapper: Codable {
    let values: [ExchangeRateMock]
    
    func loadJSON() -> [ExchangeRateMock]? {
        guard let url = Bundle.main.url(forResource: "responseMock", withExtension: "json") else {
            print("File not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let exchangeRates = try JSONDecoder().decode([ExchangeRateMock].self, from: data)
            return exchangeRates
        } catch {
            print("Error loading or parsing JSON: \(error)")
            return nil
        }
    }
}
