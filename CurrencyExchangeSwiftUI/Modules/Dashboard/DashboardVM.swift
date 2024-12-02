//
//  DashboardVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.11.2024.
//

import Foundation

class DashboardVM: ObservableObject {
    let chartVM: ChartVM
    let listVM: ListVM
    let bestRatesVM: BestRatesVM
    let conversionVM: ConversionVM
    
    init(chartVM: ChartVM, listVM: ListVM, bestRatesVM: BestRatesVM, conversionVM: ConversionVM) {
        self.chartVM = chartVM
        self.listVM = listVM
        self.bestRatesVM = bestRatesVM
        self.conversionVM = conversionVM
    }
}




