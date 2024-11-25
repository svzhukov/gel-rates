//
//  Untitled.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 23.11.2024.
//

import Foundation
import SwiftUI

extension View {
    func chartXAxisConfiguration(for timeRange: TimeRange?) -> some View {
        modifier(ChartAxisModifier(timeRange: timeRange))
    }
}
