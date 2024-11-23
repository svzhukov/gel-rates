//
//  Array+RatesGraphDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 23.11.2024.
//

import Foundation

extension Array where Element == RatesChartDisplayItem {
    var minPrice: RatesChartDisplayItem? {
        self.min(by: { $0.price < $1.price })
    }
    
    var maxPrice: RatesChartDisplayItem? {
        self.max(by: { $0.price < $1.price })
    }
}
