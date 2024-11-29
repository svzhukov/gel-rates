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
        let chartVM = ChartVM(service: ChartService())
        let listVM = ListVM(service: ListService())
        let dashboardVM = DashboardVM(chartVM: chartVM, listVM: listVM)
        let view = DashboardView(dashboardVM: dashboardVM)
        
        return view
    }
    
    static func createChartView() -> ChartView {
        let service = ChartService()
        let vm = ChartVM(service: service)
        let view = ChartView(vm: vm)
        
        return view
    }
    
    static func createListView() -> ListView {
        let service = ListService()
        let vm = ListVM(service: service)
        let view = ListView(vm: vm)
        
        return view
    }
}
