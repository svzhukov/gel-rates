//
//  RatesGraphDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 07.11.2024.
//

import Foundation

struct RatesGraphDisplayItem {
    let date: Date
    let price: Double
    
    static func mapFrom(model: TwelveExchangeRateModel) -> [RatesGraphDisplayItem] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return model.values.compactMap { value in
            guard let price = Double(value.close) else { return nil }
            guard let date = dateFormatter.date(from: value.datetime) else { return nil }
            return RatesGraphDisplayItem(
                date: date,
                price: 1 / price
            )
        }
    }
}
