//
//  ConversionDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation

struct ConversionDisplayItem: Equatable {
    typealias DisplayItemType = ConversionDisplayItem
    
    var currencies: [Currency]
    
    static func mapModel(_ model: MyfinJSONModel) -> ConversionDisplayItem {
        let currencyDict: [String: Currency] = model.best.mapValues { (rate: CurrencyRate) in
            return Currency(buy: rate.buy, sell: rate.sell, type: Constants.CurrencyType(rawValue: rate.ccy)!)
        }
        
        var currencies = Array(currencyDict.values)
        currencies.append(Currency(buy: 1, sell: 1, type: Constants.CurrencyType.gel)) // Rates are to GEL itself so it's 1, 1
        
        let sorted = currencies.sorted { c1, c2 in
            c1.type.sortOrder < c2.type.sortOrder
        }
        
        return ConversionDisplayItem(currencies: sorted)
    }
    
    static func filterItemByCurrency(_ item: ConversionDisplayItem?, currencyTypes: [Constants.CurrencyType]) -> ConversionDisplayItem? {
        let currencies = item?.currencies.filter { currency in
            currencyTypes.contains { type in
                type == currency.type
            }
        }
        return ConversionDisplayItem(currencies: currencies!)
    }
}
