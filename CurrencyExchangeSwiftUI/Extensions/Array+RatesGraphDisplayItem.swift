//
//  Array+RatesGraphDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 23.11.2024.
//

import Foundation

extension Array where Element == ChartDisplayItem {
    var minPrice: ChartDisplayItem? {
        self.min(by: { $0.price < $1.price })
    }
    
    var maxPrice: ChartDisplayItem? {
        self.max(by: { $0.price < $1.price })
    }
}
