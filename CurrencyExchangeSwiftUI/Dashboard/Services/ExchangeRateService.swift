//
//  CurrencyRateService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.10.2024.
//

import Foundation

protocol ExchangeRateServiceProtocol {
    func fetchAnnualRates(completion: @escaping (APITwelveExchangeRate) -> Void)
}

class ExchangeRateService: ExchangeRateServiceProtocol {
    func fetchAnnualRates(completion: @escaping (APITwelveExchangeRate) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let exchangeRatesResponse: APITwelveExchangeRate = self.loadJSON("APITwelveExchangeRateResponseMock.json")
            completion(exchangeRatesResponse)
        }
    }
    
    func loadJSON<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
            print(data)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(T.self, from: data)
            print(decoded)
            return decoded
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}

