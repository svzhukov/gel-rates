//
//  ExchangeListDisplayItem.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

struct ListDisplayItem: Identifiable {
    typealias DisplayItemType = ListDisplayItem
    
    let id = UUID()
    var bank: Bank
    let best: [Currency]
    
    static func mapModel(_ model: MyfinJSONModel) -> [ListDisplayItem] {
        let items: [ListDisplayItem] = model.organizations.compactMap { (org: Organization) in
            var best: [Currency] = []
            let currenciesDict: [String: Currency] = org.best.mapValues { (value: CurrencyRate) in
                best.append(Currency(buy: model.best[value.ccy]!.buy, sell: model.best[value.ccy]!.sell, type: Constants.CurrencyType(rawValue: value.ccy)!))
                return Currency(buy: value.buy, sell: value.sell, type: Constants.CurrencyType(rawValue: value.ccy)!)
            }
            let currencies = Array(currenciesDict.values).sorted { c1, c2 in
                c1.type.sortOrder < c2.type.sortOrder
            }
            let bank = Bank(id: org.id,
                            name: org.name,
                            type: Bank.OrgType(rawValue: org.type)!,
                            icon: Icon(name: URL(fileURLWithPath: org.icon).deletingPathExtension().lastPathComponent, fileExtension: URL(fileURLWithPath: org.icon).pathExtension),
                            currencies: currencies)
            
            return ListDisplayItem (bank: bank, best: best)
        }
        return items
    }
    
    static func filterItemsWithCurrencyTypes(_ allItems: [ListDisplayItem]?, currencyTypes: [Constants.CurrencyType]) -> [ListDisplayItem]? {
        if var items = allItems {
            for i in items.indices {
                items[i].bank.currencies = items[i].bank.currencies.filter { currencyTypes.contains($0.type) }
            }
            return items
        }
        return nil
    }
}


