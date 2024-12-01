//
//  BestRatesDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation

struct BestRatesDisplayItem: Identifiable {
    let id = UUID()
    let currency: Currency
    
    static func mapModel(_ model: MyfinAPIModel) -> [BestRatesDisplayItem] {
        let currencyDict: [String: Currency] = model.best.mapValues { (rate: CurrencyRate) in
            return Currency(buy: rate.buy, sell: rate.sell, type: Currency.CurrencyType(rawValue: rate.ccy)!)
        }
        
        let currencies = Array(currencyDict.values).sorted { c1, c2 in
            c1.type.sortOrder < c2.type.sortOrder
        }
        
        return currencies.compactMap { currency in
            BestRatesDisplayItem(currency: currency)
        }
    }
}
