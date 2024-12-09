//
//  ExchangeListService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

protocol ListServiceProtocol {
    func fetchListRates(completion: @escaping (Result<MyfinJSONModel, Error>) -> Void)
}

class ListService: ListServiceProtocol {
    let store: StorageManagerProtocol

    var isFetching: Bool = false
    var callbacks: [(Result<MyfinJSONModel, Error>) -> Void] = []
    
    init(store: StorageManagerProtocol) {
        self.store = store
    }
    
    func fetchListRates(completion: @escaping (Result<MyfinJSONModel, Error>) -> Void) {
        callbacks.append(completion)
        if isFetching { return }
        isFetching = true
                            
        if shouldReuseCachedData(MyfinJSONModel.self), let cachedData = store.loadJSONModel(type: MyfinJSONModel.self) {
            print("Reusing fetchListRates cached data...")
            DispatchQueue.main.async {
                for index in self.callbacks.indices.reversed() {
                    self.callbacks[index](.success(cachedData))
                    self.callbacks.remove(at: index)
                }
                self.isFetching = false
            }
            return
        }
        
        DispatchQueue.global().async {            
            NetworkClient.shared.request(url: URL(string: Constants.APIType.myfin.endpoint)!,
                                         method: Constants.Network.Method.post,
                                         headers: Constants.Network.Headers.json.dictionary,
                                         body: self.requestBody()) { [weak self] (result: Result<MyfinJSONModel, Error>) in
                switch result {
                case .success(let model):
                    self?.store.saveJSONModel(data: model)
                case .failure(_):
                    fatalError("manage api errors here")
                }
                
                if let indices = self?.callbacks.indices.reversed() {
                    DispatchQueue.main.async {
                        for index in indices {
                            self?.callbacks[index](result)
                            self?.callbacks.remove(at: index)
                        }
                        self?.isFetching = false
                    }
                }                
            }
        }
    }
    
    func lastfetchTimestamp() -> Date? {
        return store.loadLastFetchTimestamp(type: MyfinJSONModel.self)
    }
    
    private func requestBody() -> Data? {
        let body: [String : Any] = ["city": AppState.shared.selectedCity.rawValue,
                                    "includeOnline": AppState.shared.includeOnline,
                                    "availability": AppState.shared.workingAvailability.rawValue]
        return try? JSONSerialization.data(withJSONObject: body)
    }
    
    private func shouldReuseCachedData<T: JSONModelProtocol>(_ type: T.Type) -> Bool {        
        guard let lastFetch = store.loadLastFetchTimestamp(type: type) else { return false }
        let should = Date().timeIntervalSince(lastFetch) < Constants.delayBeforeNewAPIRequest
        return should
    }
}
