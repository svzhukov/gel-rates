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
    
    init(chartVM: ChartVM, listVM: ListVM) {
        self.chartVM = chartVM
        self.listVM = listVM
    }
}




