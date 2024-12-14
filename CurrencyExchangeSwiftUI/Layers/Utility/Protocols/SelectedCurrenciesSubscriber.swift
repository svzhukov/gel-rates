//
//  SelectedCitySubscriber.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 08.12.2024.
//

import Combine

protocol SelectedCurrenciesSubscriber: AnyObject {
    associatedtype DisplayItemType
    var cancellables: Set<AnyCancellable> { get set }
    var allItems: [DisplayItemType]? { get }
    
    func subscribeToSelectedCurrencies(onChange: @escaping ([Constants.CurrencyType]) -> Void)
}

extension SelectedCurrenciesSubscriber {
    func subscribeToSelectedCurrencies(onChange: @escaping ([Constants.CurrencyType]) -> Void) {
        AppState.shared.$selectedCurrencies
            .filter { [weak self] newCurrencyTypes in
                self?.allItems != nil
            }
            .sink { newCurrencyTypes in
                onChange(newCurrencyTypes)
            }
            .store(in: &cancellables)
    }
}
