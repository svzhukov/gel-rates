//
//  ConversionVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation
import Combine

class ConversionVM: ObservableObject {
    var service: ListServiceProtocol
    @Published var item: ConversionDisplayItem?

    private var cancellables = Set<AnyCancellable>()

    init(service: ListServiceProtocol) {
        self.service = service
        
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
                self?.item = ConversionDisplayItem.mapModel(model)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
