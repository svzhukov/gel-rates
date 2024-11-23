//
//  RatesGraphDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 07.11.2024.
//

import Foundation

struct RatesChartDisplayItem: Identifiable, Equatable {
    let date: Date
    let price: Double
    let id = UUID()
    
    static func mapFrom(model: TwelveExchangeRateModel) -> [RatesChartDisplayItem] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return model.values.compactMap { value in
            guard let price = Double(value.close) else { return nil }
            guard let date = dateFormatter.date(from: value.datetime) else { return nil }
            return RatesChartDisplayItem(
                date: date,
                price: 1 / price
            )
        }
    }
}
