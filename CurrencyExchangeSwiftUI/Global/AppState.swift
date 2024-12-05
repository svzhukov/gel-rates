//
//  AppState.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 05.12.2024.
//

import Foundation

class AppState: ObservableObject {
    let shared: AppState = AppState()
    private init() {}
    
    @Published var selectedCity: Constants.City = Constants.City.tbilisi
    @Published var selectedCurrencies: [Currency.CurrencyType] = [Currency.CurrencyType.gel, Currency.CurrencyType.usd]
    @Published private var includeOnline = false
    @Published private var workingNow = false
}
