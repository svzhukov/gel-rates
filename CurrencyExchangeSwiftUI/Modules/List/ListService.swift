//
//  ExchangeListService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

protocol ListServiceProtocol {
    func fetchBanksExchangeRates(completion: @escaping (Result<MyfinAPIModel, Error>) -> Void)
}

class ListService: ListServiceProtocol {
    func fetchBanksExchangeRates(completion: @escaping (Result<MyfinAPIModel, Error>) -> Void) {
        
        if shouldReuseCachedData(MyfinAPIModel.self), let cachedData = StorageManager.shared.loadCachedData(type: MyfinAPIModel.self) {
            print("Reusing cached data...")
            completion(.success(cachedData))
            return
        }
        
        DispatchQueue.global().async {            
            NetworkClient.shared.request(url: URL(string: Constants.APIType.myfin.endpoint)!,
                                         method: Constants.Network.Method.post,
                                         headers: Constants.Network.Headers.json.dictionary,
                                         body: self.requestBody()) { (result: Result<MyfinAPIModel, Error>) in
                switch result {
                case .success(let model):
                    StorageManager.shared.saveDataToCache(data: model)
                case .failure(_):
                    fatalError("manage api errors here")
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    private func requestBody() -> Data? {
        let body: [String : Any] = ["city": "tbilisi",
                        "includeOnline": true,
                        "availability": "All"]
        return try? JSONSerialization.data(withJSONObject: body)
    }
    
    private func shouldReuseCachedData<T: APIModelProtocol>(_ type: T.Type) -> Bool {
        let timeout: Double = 600
        guard let lastFetch = StorageManager.shared.loadLastFetchTimestamp(type: type) else { return false }
        return Date().timeIntervalSince(lastFetch) < timeout
    }
}
