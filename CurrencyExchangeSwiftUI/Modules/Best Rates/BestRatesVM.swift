//
//  BestRatesVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation

class BestRatesVM: ObservableObject {
    var service: ListServiceProtocol
    
    @Published var items: [BestRatesDisplayItem]?
    let title = translated("Best offers")
    let headers = [translated("Currency"), translated("Buy"), translated("Sell")]
    
    init(service: ListServiceProtocol, currencies: [BestRatesDisplayItem]? = nil) {
        self.service = service
        self.items = currencies
    }
    
    func fetchData() {
        self.service.fetchListRates{ [weak self] (result: Result<MyfinAPIModel, any Error>) in
            switch result {
            case .success(let model):
                self?.items = BestRatesDisplayItem.mapModel(model)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
