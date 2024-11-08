//
//  CurrencyRatesResponse.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.10.2024.
//

import Foundation

struct APITwelveExchangeRate: Codable {
    let meta: Meta
    let values: [CurrencyValue]
    let status: String
    
    struct Meta: Codable {
        let symbol: String
        let interval: String
        let currency_base: String
        let currency_quote: String
        let type: String
    }

    struct CurrencyValue: Codable {
        let datetime: String
        let open: String
        let high: String
        let low: String
        let close: String
    }
    
    func mapToDisplayItems() -> [RatesGraphDisplayItem] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return values.compactMap { value in
            guard let price = Double(value.close) else { return nil }
            guard let date = dateFormatter.date(from: value.datetime) else { return nil }
            return RatesGraphDisplayItem(
                date: date,
                price: 1 / price
            )
        }
    }
}

