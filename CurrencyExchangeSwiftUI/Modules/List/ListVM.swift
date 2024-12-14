//
//  ExchangeListViewModel.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation
import Combine

class ListVM: ObservableObject, OptionsSubscriber, SelectedCurrenciesSubscriber {
    var service: LiveExchangeRateServiceProtocol
    
    var allItems: [ListDisplayItem]?
    @Published var listItems: [ListDisplayItem]?
    var cancellables = Set<AnyCancellable>()

    init(service: LiveExchangeRateServiceProtocol) {
        print("ListVM init")

        self.service = service
        
        subscribeToOptionChanges(cancellables: &cancellables) { [weak self] _, _, _ in
            self?.fetchData()
        }
        subscribeToSelectedCurrencies { [weak self] newCurrencyTypes in
            self?.listItems = ListDisplayItem.filterItemsWithCurrencyTypes(self?.allItems, currencyTypes: newCurrencyTypes)
        }
    }
    
    deinit {
        print("ListVM deint")
    }
    
    func fetchData() {
        self.service.fetchLiveRates{ [weak self] (result: Result<MyfinJSONModel, any Error>) in
            switch result {
            case .success(let model):
                self?.allItems = ListDisplayItem.mapModel(model)
                self?.listItems = ListDisplayItem.filterItemsWithCurrencyTypes(self?.allItems, currencyTypes: AppState.shared.selectedCurrencies)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}



