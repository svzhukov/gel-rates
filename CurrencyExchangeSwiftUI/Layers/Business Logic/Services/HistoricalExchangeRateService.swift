//
//  CurrencyRateService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.10.2024.
//

import Foundation

protocol HistoricalExchangeRateServiceProtocol {
    func fetchHistoricalRates(completion: @escaping (Result<TwelvedataJSONModel, Error>) -> Void)
}

class HistoricalExchangeRateService: BaseService, HistoricalExchangeRateServiceProtocol {
    func fetchHistoricalRates(completion: @escaping (Result<TwelvedataJSONModel, Error>)  -> Void) {        
        if shouldReuseCachedData(key: TwelvedataJSONModel.apiType.timestampKey), let cachedData = loadModel() {
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
                    self?.saveModel(model)
                case .failure(_):
                    fatalError("manage api errors here")
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    private func saveModel(_ model: TwelvedataJSONModel) {
        save(model, key: TwelvedataJSONModel.apiType.cacheKey)
    }
    
    private func loadModel() -> TwelvedataJSONModel? {
        guard let model = load(TwelvedataJSONModel.self, key: TwelvedataJSONModel.apiType.cacheKey) as? TwelvedataJSONModel else { return nil }
        return model
    }
    
    private func urlTwelveAPI(from: Constants.CurrencyType = .usd,
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
}



