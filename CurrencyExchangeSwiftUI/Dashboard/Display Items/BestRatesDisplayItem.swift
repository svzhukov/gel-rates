//
//  Currency.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.10.2024.
//

import Foundation

struct BestRatesDisplayItem: Identifiable {
    let id = UUID()
    let name: String
    let buy: Double
    let sell: Double
    let iconName: String?
}
