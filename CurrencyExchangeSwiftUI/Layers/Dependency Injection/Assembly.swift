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
        let store = StorageManager(userDefaults: UserDefaults.standard)
        let listService = LiveExchangeRateService(store: store)
        let chartVM = ChartVM(service: HistoricalExchangeRateService(store: store))
        let bestVM = BestRatesVM(service: listService)
        let conversionVM = ConversionVM(service: listService)
        let dashboardVM = DashboardVM(chartVM: chartVM, bestRatesVM: bestVM, conversionVM: conversionVM)
        
        let view = DashboardView(dashboardVM: dashboardVM)
        
        return view
    }
    
    static func createListView() -> ListView {
        let store = StorageManager(userDefaults: UserDefaults.standard)
        let service = LiveExchangeRateService(store: store)
        let vm = ListVM(service: service)
        let view = ListView(vm: vm)
        
        return view
    }
    
    static func configureAppState() {
        let store = StorageManager(userDefaults: UserDefaults.standard)
        AppState.configure(store: store, liveService: LiveExchangeRateService(store: store), prefService: PreferencesService(store: store))
    }
}
