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
        ZStack() {
            ScrollView(.vertical) {
                VStack {
                    title()
                    OptionsView()
                    ConversionView(vm: vm.conversionVM)
                    BestRatesView(vm: vm.bestRatesVM)
                    NavigationLink(destination: ListView(vm: vm.listVM)) {
                        Text(translated("Show full list of exchangers"))
                            .padding(.top, -10)
                    }
                    if #available(iOS 16.0, *) {
                        ChartView(vm: vm.chartVM)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .availabilityScrollDismissesKeyboard()
        }
        .background(state.theme.backgroundColor)
    }
    
    private func title() -> some View {
        Text(vm.title)
            .titleStyle(state)
            .frame(maxWidth: .infinity)
            .background(state.theme.backgroundColor)
            .zIndex(1)
    }
}

#Preview {
    Assembly.createDashboardView()
}
