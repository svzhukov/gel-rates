//
//  ConversionVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation

class ConversionVM: ObservableObject {
    var service: ListServiceProtocol
    @Published var item: ConversionDisplayItem?

    init(service: ListServiceProtocol) {
        self.service = service
    }
    
    func fetchData() {
        self.service.fetchListRates{ [weak self] (result: Result<MyfinJSONModel, any Error>) in
            switch result {
            case .success(let model):
                self?.item = ConversionDisplayItem.mapModel(model)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
