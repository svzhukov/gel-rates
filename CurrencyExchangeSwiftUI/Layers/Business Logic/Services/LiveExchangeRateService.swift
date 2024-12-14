//
//  ExchangeListService.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation

protocol LiveExchangeRateServiceProtocol {
    func fetchLiveRates(completion: @escaping (Result<MyfinJSONModel, Error>) -> Void)
    
    func saveModel(_ model: MyfinJSONModel)
    func loadModel() -> MyfinJSONModel?
    
    func saveModelTimestamp(_ date: Date)
    func loadModelTimestamp() -> Date?

    func saveSelectedCurrencies(currencies: [Constants.CurrencyType])
    func loadSelectedCurrencies() -> [Constants.CurrencyType]?

    func saveCity(city: Constants.City)
    func loadCity() -> Constants.City?

    func saveIncludeOnline(include: Bool)
    func loadIncludeOnline() -> Bool?

    func saveWokingAvailability(working: Constants.Options.Availability)
    func loadWokingAvailability() -> Constants.Options.Availability?
}

class LiveExchangeRateService: BaseService, LiveExchangeRateServiceProtocol {
    private var callbacks: [(Result<MyfinJSONModel, Error>) -> Void] = []

    func fetchLiveRates(completion: @escaping (Result<MyfinJSONModel, Error>) -> Void) {
        callbacks.append(completion)
        if isFetching { return }
        isFetching = true
                            
        if shouldReuseCachedData(key: MyfinJSONModel.apiType.timestampKey), let cachedData = loadModel() {
            print("Reusing fetchListRates cached data...")
            invokeCallbacks(.success(cachedData))
            return
        }
        
        DispatchQueue.global().async {            
            NetworkClient.shared.request(url: URL(string: Constants.APIType.myfin.endpoint)!,
                                         method: Constants.Network.Method.post,
                                         headers: Constants.Network.Headers.json.dictionary,
                                         body: self.requestBody()) { [weak self] (result: Result<MyfinJSONModel, Error>) in
                switch result {
                case .success(let model):
                    self?.saveModel(model)
                case .failure(_):
                    fatalError("manage api errors here")
                }
                
                self?.invokeCallbacks(result)
            }
        }
    }
    
    // MARK: - Model
    func saveModel(_ model: MyfinJSONModel) {
        save(model, key: MyfinJSONModel.apiType.cacheKey)
        saveModelTimestamp(Date())
    }
    
    func loadModel() -> MyfinJSONModel? {
        guard let model = load(MyfinJSONModel.self, key: MyfinJSONModel.apiType.cacheKey) as? MyfinJSONModel else { return nil }
        return model
    }
    
    func saveModelTimestamp(_ date: Date) {
        save(date, key: MyfinJSONModel.apiType.timestampKey)
    }
    
    func loadModelTimestamp() -> Date? {
        guard let timestamp = load(Date.self, key: MyfinJSONModel.apiType.timestampKey) as? Date else { return nil }
        return timestamp
    }
    
    // MARK: - Options
    func saveSelectedCurrencies(currencies: [Constants.CurrencyType]) {
        save(currencies, key: Constants.CurrencyType.cacheKey)
    }

    func loadSelectedCurrencies() -> [Constants.CurrencyType]? {
        if let currencies = load([Constants.CurrencyType].self, key: Constants.CurrencyType.cacheKey) as? [Constants.CurrencyType] {
            return currencies
        }
        return nil
    }

    func saveCity(city: Constants.City) {
        save(city, key: Constants.City.cacheKey)
    }

    func loadCity() -> Constants.City? {
        if let city = load(Constants.City.self, key: Constants.City.cacheKey) as? Constants.City {
            return city
        }
        return nil
    }

    func saveIncludeOnline(include: Bool) {
        save(include, key: Constants.Options.IncludeOnline.cacheKey)
    }

    func loadIncludeOnline() -> Bool? {
        if let include = load(Bool.self, key: Constants.Options.IncludeOnline.cacheKey) as? Bool{
            return include
        }
        return nil
    }

    func saveWokingAvailability(working: Constants.Options.Availability) {
        save(working, key: Constants.Options.Availability.cacheKey)
    }

    func loadWokingAvailability() -> Constants.Options.Availability? {
        if let working = load(Constants.Options.Availability.self, key: Constants.Options.Availability.cacheKey) as? Constants.Options.Availability {
            return working
        }
        return nil
    }
    
    // MARK: - Private
    private func requestBody() -> Data? {
        let body: [String : Any] = ["city": loadCity()?.rawValue ?? Constants.City.defaultValue.rawValue,
                                    "includeOnline": loadIncludeOnline() ?? Constants.Options.IncludeOnline.defaultValue.rawValue,
                                    "availability": loadWokingAvailability()?.rawValue ?? Constants.Options.Availability.defaultValue.rawValue]
        return try? JSONSerialization.data(withJSONObject: body)
    }
    
    private func invokeCallbacks(_ result: Result<MyfinJSONModel, Error>) {
        DispatchQueue.main.async {
            let indices = self.callbacks.indices.reversed()
            for index in indices {
                self.callbacks[index](result)
                self.callbacks.remove(at: index)
            }
            self.isFetching = false
        }
    }
}
