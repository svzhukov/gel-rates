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
    func fetchAnnualRates(completion: @escaping (Result<TwelveExchangeRateModel, Error>)  -> Void) {
        DispatchQueue.global().async {
            guard let url = self.urlTwelveAPI()
            else { return }
            
            NetworkClient.shared.request(url) { result in
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
        
        print(Bundle.main.infoDictionary ?? "No Info.plist found")

        
        let url =         "\(APIType.twelve.endpoint)?symbol=\(from)/\(to)&interval=\(interval)day&start_date=\(startString)&end_date=\(endString)&apikey=\(APIType.twelve.apikey)"
        print(url)
        
        return URL(string: url)
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
}



