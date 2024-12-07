//
//  BestRatesVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation
import Combine

class BestRatesVM: ObservableObject {
    var service: ListServiceProtocol
    
    @Published var items: [BestRatesDisplayItem]?
    @Published var title: String = "Best offers"
    let headers = ["Currency", "Buy", "Sell"]
    
    private var cancellables = Set<AnyCancellable>()

    init(service: ListServiceProtocol, currencies: [BestRatesDisplayItem]? = nil) {
        self.service = service
        self.items = currencies
                
        Publishers.CombineLatest3(AppState.shared.$selectedCity, AppState.shared.$includeOnline, AppState.shared.$workingAvailability)
            .dropFirst()
            .sink { [weak self] (newValue1, newValue2, newValue3) in
                self?.fetchData()
            }
            .store(in: &cancellables)
    }
    
    func fetchData() {
        self.service.fetchListRates{ [weak self] (result: Result<MyfinJSONModel, any Error>) in
            switch result {
            case .success(let model):
                self?.items = BestRatesDisplayItem.mapModel(model)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
