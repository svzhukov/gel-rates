//
//  Bank.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 26.11.2024.
//

import Foundation

struct Bank {
    let id: String
    let name: Organization.TranslatedName
    let type: OrgType
    let icon: Icon
    let currencies: [Currency]
    
    enum OrgType {
        case bank
        case microfinance
        case online
        
        init?(rawValue: String) {
            switch rawValue.lowercased() {
            case "online":
                self = .online
            case "bank":
                self = .bank
            case "microfinanceorganization":
                self = .microfinance
            default:
                fatalError("OrgType not found: \(rawValue)")
            }
        }
    }
}

struct Icon {
    let name: String
    let fileExtension: String
}
