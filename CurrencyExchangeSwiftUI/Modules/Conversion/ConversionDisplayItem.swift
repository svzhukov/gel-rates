//
//  ConversionDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation

struct ConversionDisplayItem {
    let currencies: [Currency]
    
    static func mapModel(_ model: MyfinJSONModel) -> ConversionDisplayItem {
        let currencyDict: [String: Currency] = model.best.mapValues { (rate: CurrencyRate) in
            return Currency(buy: rate.buy, buyBest: rate.buy, sell: rate.sell, sellBest: rate.sell, type: Currency.CurrencyType(rawValue: rate.ccy)!)
        }
        
        var currencies = Array(currencyDict.values)
        currencies.append(Currency(buy: 1, buyBest: 1, sell: 1, sellBest: 1, type: Currency.CurrencyType.gel)) // Rates are to GEL itself
        
        let sorted = currencies.sorted { c1, c2 in
            c1.type.sortOrder < c2.type.sortOrder
        }
        
        return ConversionDisplayItem(currencies: sorted)
    }
}
