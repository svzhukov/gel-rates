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
    @Published var title: String = "Best offers"
    let headers = ["Currency", "Buy", "Sell"]
    
    init(service: ListServiceProtocol, currencies: [BestRatesDisplayItem]? = nil) {
        self.service = service
        self.items = currencies
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
    
    private func updateTitle(_ model: MyfinJSONModel) {
        let now = model.lastfetchTimestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: now)
        title = "Best offers" + " " + "on" + " \(formattedDate)"
    }
}
