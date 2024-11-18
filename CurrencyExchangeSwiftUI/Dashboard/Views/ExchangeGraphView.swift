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
                .frame(height: 300)
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
        if let items = self.vm.graphItems {
            Chart {
                AreaPlot(
                    items,
                    x: .value("Date", \.date),
                    y: .value("Price", \.price)
                )
                .opacity(0.2)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 1)) {
                    AxisGridLine()

                }
                AxisMarks(values: .stride(by: .month, count: 2)) {
//                    AxisTick()
                    AxisValueLabel(format: .dateTime.month())
                }
            }
            .chartYScale(domain: DynamicYScaleChart())
            .clipShape(RoundedRectangle(cornerRadius: 15))
        } else {
            ProgressView("Loading...")
        }
    }
    
    func DynamicYScaleChart() -> ClosedRange<Double> {
        let min = self.vm.graphItems!.compactMap { $0.price }.min()!
        var max = self.vm.graphItems!.compactMap { $0.price }.max()!
        max = round(max * 100) / 100 + 0.001
        
        return min...max
    }
}

#Preview {
    AppAssembly.createDashboardView()
}
