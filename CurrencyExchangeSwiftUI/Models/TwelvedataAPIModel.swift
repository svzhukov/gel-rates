//
//  CurrencyRatesResponse.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.10.2024.
//

import Foundation

struct TwelvedataAPIModel: APIModelProtocol {
    
    static let apiType: Constants.APIType = Constants.APIType.twelvedata

    let meta: Meta
    let values: [CurrencyValue]
    let status: String
    
    struct Meta: Codable {
        let symbol: String
        let interval: String
        let currency_base: String
        let currency_quote: String
        let type: String
    }

    struct CurrencyValue: Codable {
        let datetime: String
        let open: String
        let high: String
        let low: String
        let close: String
    }
}

