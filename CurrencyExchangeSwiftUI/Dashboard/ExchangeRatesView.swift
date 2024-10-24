//
//  ExchangeRatesView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.10.2024.
//

import Foundation
import SwiftUI

struct ExchangeRatesView: View {
    let title = "BEST OFFERS"
    let mockHeaders = ["Currency", "Buy", "Sell"]
    let mockData = [
        ["USD", "2.73", "2.736"],
        ["EUR", "2.735", "2.735"],
        ["100 RUB", "2.91", "2.95"]
    ]
    
    var body: some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.secondary)
                .padding(.leading, 30)
                .padding(.bottom, -5)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "d8dad3"))
                .frame(height: CGFloat(40 * (mockData.count + 1)))
                .overlay(
                    VStack {
                        Grid(alignment: .center) {
                            GridRow {
                                ForEach(mockHeaders, id: \.self) { header in
                                    Text(header)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                }
                            }
                            Divider()
                            ForEach(Array(mockData.enumerated()), id: \.offset) { rowIndex, row in
                                GridRow {
                                    ForEach(Array(row.enumerated()), id: \.offset) { columnIndex, item in
                                        Text(item)
                                            .font(.body)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    }
                                }
                            }
                        }
                    }
                )
//                .padding()
        }
    }
}
