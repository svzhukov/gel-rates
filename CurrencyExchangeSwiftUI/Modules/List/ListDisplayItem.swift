//
//  ExchangeListDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

struct ListDisplayItem: Identifiable {
    let id = UUID()
    let bank: MyfinAPIModel.Organization
    let currencies: [Currency]
    
    static func mapModel(_ model: MyfinAPIModel) -> [ListDisplayItem] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let items: [ListDisplayItem] = model.organizations.compactMap { (org: MyfinAPIModel.Organization) in
            let currencies: [String : Currency] = org.best.mapValues { (value: MyfinAPIModel.CurrencyRate) in
                Currency(buy: value.buy, sell: value.sell, type: Currency.CurrencyType(rawValue: value.ccy)!)
            }
            return ListDisplayItem (bank: org, currencies: Array(currencies.values))
        }
        
        return items
    }
}
