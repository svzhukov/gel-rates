//
//  CurrencyRateService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.10.2024.
//

import Foundation

protocol ChartServiceProtocol {
    func fetchAnnualRates(completion: @escaping (Result<TwelvedataJSONModel, Error>) -> Void)
}

class ChartService: ChartServiceProtocol {
    let store: StorageManagerProtocol
    
    init(store: StorageManagerProtocol) {
        self.store = store
    }
    
    func fetchAnnualRates(completion: @escaping (Result<TwelvedataJSONModel, Error>)  -> Void) {        
        if shouldReuseCachedData(TwelvedataJSONModel.self), let cachedData = store.loadJSONModel(type: TwelvedataJSONModel.self) {
            print("Reusing fetchAnnualRates cached data...")
            completion(.success(cachedData))
            return
        }
        
        DispatchQueue.global().async {
            guard let url = self.urlTwelveAPI()
            else { return }
            
            NetworkClient.shared.request(url: url) { [weak self] (result: Result<TwelvedataJSONModel, Error>) in
                switch result {
                case .success(let model):
                    self?.store.saveJSONModel(data: model)
                case .failure(_):
                    fatalError("manage api errors here")
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func urlTwelveAPI(from: Constants.CurrencyType = .usd,
                      to: Constants.CurrencyType = .gel,
                      interval: UInt = 1,
                      start: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
                      end: Date = Date()) -> URL? {
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let endString = dateFormatter.string(from: end)
        let startString = dateFormatter.string(from: start)
        
        let url =         "\(Constants.APIType.twelvedata.endpoint)?symbol=\(from)/\(to)&interval=\(interval)day&start_date=\(startString)&end_date=\(endString)&apikey=\(Constants.APIType.twelvedata.apikey)"
        
        return URL(string: url)
    }
    
    private func shouldReuseCachedData<T: JSONModelProtocol>(_ type: T.Type) -> Bool {
        guard let lastFetch = store.loadLastFetchTimestamp(type: type) else { return false }
        let should = Date().timeIntervalSince(lastFetch) < Constants.delayBeforeNewAPIRequest
        return should
    }
}



