//
//  BestRatesVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation
import Combine

class BestRatesVM: ObservableObject, OptionsSubscriber, SelectedCurrenciesSubscriber {
    
    var service: LiveExchangeRateServiceProtocol
    
    var allItems: [BestRatesDisplayItem]?
    @Published var items: [BestRatesDisplayItem]?
    @Published var title: String = "Best offers"
    let headers = ["Currency", "Buy", "Sell"]
    
    var cancellables = Set<AnyCancellable>()
    
    deinit {
        print("BestRatesVM deinit")
    }

    init(service: LiveExchangeRateServiceProtocol, currencies: [BestRatesDisplayItem]? = nil) {
        
        print("BestRatesVM init")
        
        self.service = service
        self.items = currencies
        
        subscribeToOptionChanges(cancellables: &cancellables) { [weak self] newCity, _, _ in
            print(newCity)
            self?.fetchData()
        }
        subscribeToSelectedCurrencies { [weak self] newCurrencyTypes in
            self?.items = BestRatesDisplayItem.filterItemsWithCurrencyTypes(self?.allItems, currencyTypes: newCurrencyTypes)
        }
    }
    
    func fetchData() {
        self.service.fetchLiveRates{ [weak self] (result: Result<MyfinJSONModel, any Error>) in
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
