//
//  Currency.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 25.11.2024.
//

import Foundation

struct Currency: Identifiable, Hashable {
    let id = UUID()
    let buy: Double
    let sell: Double
    let type: Constants.CurrencyType
    var name: String {
        return type.rawValue
    }
}

extension Array where Element == Currency {
    func currency(for type: Constants.CurrencyType) -> Currency? {
        return self.first { currency in
            currency.type == type
        }
    }
}
