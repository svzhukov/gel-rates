//
//  ExchangeRatesMock.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.10.2024.
//

import Foundation

struct ExchangeRateMock: Identifiable, Codable {
    let date: Date
    let value: Double
    var id: UUID = UUID()
    
    static func mockData() -> [ExchangeRateMock] {
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -365, to: today)!

        var previousValue = 0.35

        let mockData: [ExchangeRateMock] = (0..<365).map { dayOffset in
            let dailyChange = Double.random(in: -0.002...0.002)
            previousValue += dailyChange

            // 1 in 50 chance for a dip
            if Int.random(in: 1...50) == 1 {
                previousValue -= Double.random(in: 0.02...0.05)
            }

            previousValue = min(max(previousValue, 0.34), 0.38)
            
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate)!
            
            return ExchangeRateMock(date: date, value: previousValue)
        }
        
        return mockData
    }
}
