//
//  CurrencyRateService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.10.2024.
//

import Foundation

protocol ChartServiceProtocol {
    func fetchAnnualRates(completion: @escaping (Result<TwelvedataAPIModel, Error>) -> Void)
}

class ChartService: ChartServiceProtocol {
    
    func fetchAnnualRates(completion: @escaping (Result<TwelvedataAPIModel, Error>)  -> Void) {        
        if shouldReuseCachedData(TwelvedataAPIModel.self), let cachedData = StorageManager.shared.loadCachedData(type: TwelvedataAPIModel.self) {
            print("Reusing fetchAnnualRates cached data...")
            completion(.success(cachedData))
            return
        }
        
        DispatchQueue.global().async {
            guard let url = self.urlTwelveAPI()
            else { return }
            
            NetworkClient.shared.request(url: url) { (result: Result<TwelvedataAPIModel, Error>) in
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
    
    func urlTwelveAPI(from: Currency.CurrencyType = .usd,
                      to: Currency.CurrencyType = .gel,
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
    
    private func shouldReuseCachedData<T: APIModelProtocol>(_ type: T.Type) -> Bool {
        let timeout: Double = 600
        guard let lastFetch = StorageManager.shared.loadLastFetchTimestamp(type: type) else { return false }
        let should = Date().timeIntervalSince(lastFetch) < timeout
        print("shouldReuseCachedData for \(type): \(should)")
        return should
    }
}



