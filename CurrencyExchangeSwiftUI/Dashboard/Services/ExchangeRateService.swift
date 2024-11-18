//
//  CurrencyRateService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.10.2024.
//

import Foundation

protocol ExchangeRateServiceProtocol {
    func fetchAnnualRates(completion: @escaping (Result<TwelveExchangeRateModel, Error>) -> Void)
}

class ExchangeRateService: ExchangeRateServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let cacheKey = UserDefaultsKeys.twelveExchangeRateModelCache.rawValue
    private let lastRequested = UserDefaultsKeys.twelveExchangeRateModelTimestamp.rawValue

    func fetchAnnualRates(completion: @escaping (Result<TwelveExchangeRateModel, Error>)  -> Void) {
        if let cachedData = loadCachedData(),
           let lastFetch = loadLastFetchTimestamp(),
           Date().timeIntervalSince(lastFetch) < 600 {
            print("Reusing cached data...")
            completion(.success(cachedData))
            return
        }
        
        DispatchQueue.global().async {
            guard let url = self.urlTwelveAPI()
            else { return }
            
            NetworkClient.shared.request(TwelveExchangeRateModel.self, url: url) { result in
                switch result {
                case .success(let model):
                    self.saveDataToCache(model)
                case .failure(_):
                    break
                }
                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func urlTwelveAPI(from: Currency = .usd,
                      to: Currency = .gel,
                      interval: UInt = 1,
                      start: Date = Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
                      end: Date = Date()) -> URL? {
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let endString = dateFormatter.string(from: end)
        let startString = dateFormatter.string(from: start)
        
        let url =         "\(APIType.twelve.endpoint)?symbol=\(from)/\(to)&interval=\(interval)day&start_date=\(startString)&end_date=\(endString)&apikey=\(APIType.twelve.apikey)"
        print(url)
        
        return URL(string: url)
    }
    
    private func loadCachedData() -> TwelveExchangeRateModel? {
        guard let data = userDefaults.data(forKey: cacheKey) else { return nil }
        return try? JSONDecoder().decode(TwelveExchangeRateModel.self, from: data)
    }
    
    private func loadLastFetchTimestamp() -> Date? {
        return userDefaults.object(forKey: lastRequested) as? Date
    }
    
    private func saveDataToCache(_ data: TwelveExchangeRateModel) {
        if let encodedData = try? JSONEncoder().encode(data) {
            userDefaults.set(encodedData, forKey: cacheKey)
            userDefaults.set(Date(), forKey: lastRequested)
            print("Cached data saved.")
        }
    }
}


// Constants
extension ExchangeRateService {
    enum APIType {
        case twelve
        case myfin
        
        var endpoint: String {
            switch self {
            case.twelve:
                return "https://api.twelvedata.com/time_series"
            case.myfin:
                return "https://myfin.ge/api/exchangeRates"
            }
        }
        
        var apikey: String {
            switch self {
            case.twelve:
                return Bundle.main.infoDictionary?["TWELVE_API_KEY"] as? String ?? "noapikeyfound"

            case.myfin:
                return ""
            }
        }
    }
    
    enum Currency: String {
        case usd = "USD"
        case gel = "GEL"
    }
    
    enum UserDefaultsKeys: String {
        case twelveExchangeRateModelCache = "TwelveExchangeRateModelCache"
        case twelveExchangeRateModelTimestamp = "TwelveExchangeRateModelTimestamp"
    }
}



