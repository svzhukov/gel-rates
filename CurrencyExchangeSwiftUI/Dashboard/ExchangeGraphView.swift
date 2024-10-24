//
//  ExchangeGraphView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.10.2024.
//

import Foundation
import SwiftUI
import Charts

struct ExchangeGraphView: View {
    let title = "GRAPH"

    var body: some View {
        VStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.secondary)
                .padding(.leading, 30)
                .padding(.bottom, -5)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "d8dad3"))
                .frame(height: 150)
                .overlay(
                    
                    Chart {
                        AreaPlot(
                            ExchangeRateMock.mockData(),
                            x: .value("Date", \.date),
                            y: .value("Price", \.value)
                        )
                        .opacity(0.2)
                        //                    .foregroundStyle(by: .value("Asset", \.symbol))
                    }
                        .padding(.leading, 12)
                        .chartYScale(domain: (0.34 - 0.01)...(0.38 + 0.01))
                        .clipped()
                    
                    
                    
                    //                Chart(ExchangeRate.mockData()) {
                    //                    LineMark(
                    //                        x: .value("Month", $0.date),
                    //                        y: .value("Value", $0.value)
                    //                    )
                    //                }
                    //                    .padding()
                    
                )
        }
    }
}
