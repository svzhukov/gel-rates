//
//  Double+FormattedDecimal.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation

extension Double {
    static func formattedDecimal(_ string: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "," 
        formatter.numberStyle = .decimal
        
        return formatter.number(from: string)?.doubleValue
    }
}
