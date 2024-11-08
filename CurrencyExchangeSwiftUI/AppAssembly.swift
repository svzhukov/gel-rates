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
        let service = ExchangeRateService()
        let vm = DashboardViewModel(service: service)
        let view = DashboardView(vm: vm)
        
        return view
    }
}
