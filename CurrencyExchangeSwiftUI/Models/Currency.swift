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
    let buyBest: Double
    let sell: Double
    let sellBest: Double
    let type: Constants.CurrencyType
    var name: String {
        return type.rawValue
    }
}
