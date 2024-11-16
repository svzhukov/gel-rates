//
//  APIMyfinExchangeRate.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 05.11.2024.
//

import Foundation

struct MyfinExchangeRateModel: Codable {
    let best: [String: CurrencyRate]
    let organizations: [Organization]
    
    struct CurrencyRate: Codable {
        let ccy: String
        let buy: Double
        let sell: Double
        let nbg: Double?
    }
    
    struct Organization: Codable {
        let id: String
        let type: String
        let link: String
        let icon: String
        let name: TranslatedName
        let bestRates: [String: CurrencyRate]
        let offices: [Office]
        
        struct Office: Codable {
            let id: String
            let name: TranslatedName
            let address: TranslatedAddress
            let icon: String?
            let workingNow: Bool
            let rates: [String: CurrencyRateWithTime]
        }
        
        struct TranslatedName: Codable {
            let en: String?
            let ka: String?
            let ru: String?
        }

        struct TranslatedAddress: Codable {
            let en: String?
            let ka: String?
            let ru: String?
        }

        struct CurrencyRateWithTime: Codable {
            let ccy: String
            let buy: Double
            let sell: Double
            let timeFrom: String?
            let time: String?
        }
    }
}




