//
//  ConversionVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation
import Combine

class ConversionVM: ObservableObject, OptionsSubscriber, SelectedCurrenciesSubscriber {
    var service: ListServiceProtocol
    
    var allItems: [ConversionDisplayItem]?
    @Published var item: ConversionDisplayItem?

    var cancellables = Set<AnyCancellable>()

    init(service: ListServiceProtocol) {
        self.service = service
        
        subscribeToOptionChanges(cancellables: &cancellables) { [weak self] _, _, _ in
            self?.fetchData()
        }
        subscribeToSelectedCurrencies { [weak self] newCurrencyTypes in
            self?.item = ConversionDisplayItem.filterItemByCurrency(self?.allItems?[0], currencyTypes: newCurrencyTypes)
        }
    }
    
    func fetchData() {
        self.service.fetchListRates{ [weak self] (result: Result<MyfinJSONModel, any Error>) in
            switch result {
            case .success(let model):
                self?.allItems = [ConversionDisplayItem.mapModel(model)]
                self?.item = ConversionDisplayItem.filterItemByCurrency(self?.allItems?[0], currencyTypes: AppState.shared.selectedCurrencies)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
}
