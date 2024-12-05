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
    var isFetching: Bool = false
    var callbacks: [(Result<MyfinJSONModel, Error>) -> Void] = []
    
    func fetchListRates(completion: @escaping (Result<MyfinJSONModel, Error>) -> Void) {
        
        callbacks.append(completion)
        if isFetching { return }
        isFetching = true
                            
        if shouldReuseCachedData(MyfinJSONModel.self), let cachedData = StorageManager.shared.loadJSONModel(type: MyfinJSONModel.self) {
            print("Reusing fetchListRates cached data...")
            DispatchQueue.main.async {
                for callback in self.callbacks {
                    callback(.success(cachedData))
                }
                self.isFetching = false
            }
            return
        }
        
        DispatchQueue.global().async {            
            NetworkClient.shared.request(url: URL(string: Constants.APIType.myfin.endpoint)!,
                                         method: Constants.Network.Method.post,
                                         headers: Constants.Network.Headers.json.dictionary,
                                         body: self.requestBody()) { (result: Result<MyfinJSONModel, Error>) in
                switch result {
                case .success(let model):
                    StorageManager.shared.saveJSONModel(data: model)
                case .failure(_):
                    fatalError("manage api errors here")
                }
                
                DispatchQueue.main.async {
                    for callback in self.callbacks {
                        callback(result)
                    }
                    self.isFetching = false
                }
            }
        }
    }
    
    func lastfetchTimestamp() -> Date? {
        return StorageManager.shared.loadLastFetchTimestamp(type: MyfinJSONModel.self)
    }
    
    private func requestBody() -> Data? {
        let body: [String : Any] = ["city": "tbilisi",
                        "includeOnline": true,
                        "availability": "All"]
        return try? JSONSerialization.data(withJSONObject: body)
    }
    
    private func shouldReuseCachedData<T: JSONModelProtocol>(_ type: T.Type) -> Bool {
        let timeout: Double = 600
        guard let lastFetch = StorageManager.shared.loadLastFetchTimestamp(type: type) else { return false }
        let should = Date().timeIntervalSince(lastFetch) < timeout
        print("shouldReuseCachedData for \(type): \(should)")
        return should
    }
}
