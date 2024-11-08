//
//  DashboardViewModel.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 05.11.2024.
//

import Foundation

class DashboardViewModel: ObservableObject {
    var bestRates: [BestRatesDisplayItem]?
    @Published var graphRates: [RatesGraphDisplayItem]?
    
    var service: ExchangeRateServiceProtocol
    
    init(service: ExchangeRateServiceProtocol) {
        self.service = service
    }
    
    func fetchData() {
        self.service.fetchAnnualRates { [weak self] response in
            DispatchQueue.main.async {
                self?.graphRates = response.mapToDisplayItems()
            }
        }
    }
}


