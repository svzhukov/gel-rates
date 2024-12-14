//
//  String+FormattedDecimal.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import Foundation

extension String {
    static func formattedDecimal(_ value: Double, maximumFractionDigits: Int = 3, separator: String = ".") -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.numberStyle = .none
        formatter.decimalSeparator = separator
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
