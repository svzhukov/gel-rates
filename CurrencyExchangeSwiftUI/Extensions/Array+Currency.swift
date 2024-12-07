//
//  Array+Currency.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 07.12.2024.
//

extension Array where Element == Currency {
    func currency(for type: Constants.CurrencyType) -> Currency? {
        return self.first { currency in
            currency.type == type
        }
    }
}
