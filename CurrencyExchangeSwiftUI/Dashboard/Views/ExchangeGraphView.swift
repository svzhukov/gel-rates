////
////  ExchangeGraphView.swift
////  CurrencyExchangeSwiftUI
////
////  Created by Sasha Zhukov on 24.10.2024.
////

import Foundation
import SwiftUI
import Charts

struct ExchangeGraphView: View {
    var vm: DashboardViewModel
    
    init(vm: DashboardViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            Text("GRAPH")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.secondary)
                .padding(.leading, 30)
                .padding(.bottom, -5)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "d8dad3"))
                .frame(height: 150)
                .overlay(ChartView(vm: self.vm))
                .frame(width: 350)
        }
        .frame(width: 350)
        .onAppear {
            self.vm.fetchData()
        }
    }
}

struct ChartView: View {
    @StateObject var vm: DashboardViewModel
    
    init(vm: DashboardViewModel) {
        _vm = StateObject(wrappedValue: vm) // ??
    }
    
    var body: some View {
        if let items = self.vm.graphRates {
            Chart {
                AreaPlot(
                    items,
                    x: .value("Date", \.date),
                    y: .value("Price", \.price)
                )
                .opacity(0.2)
            }
            .padding(.leading, 12)
            .chartYScale(domain: (0.34 - 0.01)...(0.38 + 0.01))
            .clipped()
        } else {
            ProgressView("Loading...")
        }
    }
}
