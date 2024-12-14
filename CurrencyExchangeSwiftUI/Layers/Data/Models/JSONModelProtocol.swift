//
//  APIModelProtocol.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 25.11.2024.
//

import Foundation

protocol JSONModelProtocol: Codable {
    static var apiType: Constants.APIType { get }
}
