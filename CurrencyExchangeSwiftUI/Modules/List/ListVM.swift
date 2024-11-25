//
//  ExchangeListViewModel.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

class ListVM: ObservableObject {
    var service: ListServiceProtocol
    @Published var listItems: [ListDisplayItem]?

    init(service: ListServiceProtocol) {
        self.service = service
    }
    
    func fetchData() {
        self.service.fetchBanksExchangeRates{ [weak self] (result: Result<MyfinAPIModel, any Error>) in
            switch result {
            case .success(let model):
                self?.listItems = ListDisplayItem.mapModel(model)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
}



