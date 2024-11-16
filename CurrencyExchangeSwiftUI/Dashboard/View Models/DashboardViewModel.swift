//
//  DashboardViewModel.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 05.11.2024.
//

import Foundation

class DashboardViewModel: ObservableObject {
    var bestRates: [BestRatesDisplayItem]?
    @Published var graphItems: [RatesGraphDisplayItem]?
    
    var service: ExchangeRateServiceProtocol
    
    init(service: ExchangeRateServiceProtocol) {
        self.service = service
    }
    
    func fetchData() {
        self.service.fetchAnnualRates { [weak self] result in
            switch result {
            case .success(let model):
                self?.graphItems = RatesGraphDisplayItem.mapFrom(model: model)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}


