//
//  ContentView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var state = AppState.shared
    @StateObject private var vm: DashboardVM
    
    init(dashboardVM: DashboardVM) {
        _vm = StateObject(wrappedValue: dashboardVM)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                title()
                OptionsView()
                BestRatesView(vm: vm.bestRatesVM)
                ConversionView(vm: vm.conversionVM)
                
                if #available(iOS 16.0, *) {
                    ChartView(vm: vm.chartVM)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .scrollDismissesKeyboardConditional()
    }
    
    private func title() -> some View {
        Text(translated(vm.title))
            .titleStyle(state)
            .frame(maxWidth: .infinity)
            .background(state.theme.backgroundColor)
            .zIndex(1)
    }
}

#Preview {
    Assembly.createDashboardView()
}
