//
//  ExchangeListDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

struct ListDisplayItem: Identifiable {
    let id = UUID()
    let bank: Bank
    
    static func mapModel(_ model: MyfinJSONModel) -> [ListDisplayItem] {
        
        let items: [ListDisplayItem] = model.organizations.compactMap { (org: Organization) in
            let currenciesDict: [String: Currency] = org.best.mapValues { (value: CurrencyRate) in
                Currency(buy: value.buy, buyBest: model.best[value.ccy]!.buy, sell: value.sell, sellBest: model.best[value.ccy]!.sell, type: Currency.CurrencyType(rawValue: value.ccy)!)
            }
            let currencies = Array(currenciesDict.values).sorted { c1, c2 in
                c1.type.sortOrder < c2.type.sortOrder
            }
            let bank = Bank(id: org.id,
                            name: org.name,
                            type: Bank.OrgType(rawValue: org.type)!,
                            icon: Icon(name: URL(fileURLWithPath: org.icon).deletingPathExtension().lastPathComponent, fileExtension: URL(fileURLWithPath: org.icon).pathExtension),
                            currencies: currencies)
            
                return ListDisplayItem (bank: bank)
        }
        return items
    }
}


