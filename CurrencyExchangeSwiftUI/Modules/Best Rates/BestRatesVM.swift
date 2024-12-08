//
//  BestRatesVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation
import Combine

class BestRatesVM: ObservableObject, OptionsSubscriber, SelectedCurrenciesSubscriber {
    
    var service: ListServiceProtocol
    
    var allItems: [BestRatesDisplayItem]?
    @Published var items: [BestRatesDisplayItem]?
    @Published var title: String = "Best offers"
    let headers = ["Currency", "Buy", "Sell"]
    
    var cancellables = Set<AnyCancellable>()

    init(service: ListServiceProtocol, currencies: [BestRatesDisplayItem]? = nil) {
        self.service = service
        self.items = currencies
        
        subscribeToOptionChanges(cancellables: &cancellables) { [weak self] _, _, _ in
            self?.fetchData()
        }
        subscribeToSelectedCurrencies { [weak self] newCurrencyTypes in
            self?.items = BestRatesDisplayItem.filterItemsWithCurrencyTypes(self?.allItems, currencyTypes: newCurrencyTypes)
        }
    }
    
    func fetchData() {
        self.service.fetchListRates{ [weak self] (result: Result<MyfinJSONModel, any Error>) in
            switch result {
            case .success(let model):
                self?.allItems = BestRatesDisplayItem.mapModel(model)
                self?.items = BestRatesDisplayItem.filterItemsWithCurrencyTypes(self?.allItems, currencyTypes: AppState.shared.selectedCurrencies)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
