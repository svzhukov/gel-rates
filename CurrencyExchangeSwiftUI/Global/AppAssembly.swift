//
//  AppAssembly.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 07.11.2024.
//

import Foundation
import SwiftUI

struct AppAssembly {
    static func createDashboardView() -> some View {
        let service = ChartService()
        let vm = ChartVM(service: service)
        let view = DashboardView(vm: vm)
        
        return view
    }
    
    static func createChartView() -> some View {
        let service = ChartService()
        let vm = ChartVM(service: service)
        let view = ChartView(vm: vm)
        
        return view
    }
    
    static func createListView() -> some View {
        let service = ListService()
        let vm = ListVM(service: service)
        let view = ListView(vm: vm)
        
        return view
    }
}
