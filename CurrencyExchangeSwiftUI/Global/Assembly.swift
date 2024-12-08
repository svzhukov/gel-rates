//
//  AppAssembly.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 07.11.2024.
//

import Foundation
import SwiftUI

struct Assembly {
    static func createDashboardView() -> DashboardView {
        let listService = ListService()
        let chartVM = ChartVM(service: ChartService())
        let bestVM = BestRatesVM(service: listService)
        let conversionVM = ConversionVM(service: listService)
        let dashboardVM = DashboardVM(chartVM: chartVM, bestRatesVM: bestVM, conversionVM: conversionVM)
        
        let view = DashboardView(dashboardVM: dashboardVM)
        
        return view
    }
    
    static func createListView() -> ListView {
        let service = ListService()
        let vm = ListVM(service: service)
        let view = ListView(vm: vm)
        
        return view
    }
}
