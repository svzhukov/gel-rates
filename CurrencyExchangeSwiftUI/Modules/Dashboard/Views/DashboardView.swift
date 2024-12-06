//
//  ContentView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var appearance = Appearance.shared
    @StateObject private var vm: DashboardVM
    
    init(dashboardVM: DashboardVM) {
        _vm = StateObject(wrappedValue: dashboardVM)
    }
    
    var body: some View {
        ZStack() {
            ScrollView(.vertical) {
                VStack {
                    Text("Some Epic Title idk")
                        .titleStyle(appearance)
                        .frame(maxWidth: .infinity)
                        .background(appearance.theme.backgroundColor)
                        .zIndex(1)
                    OptionsView()
                    ConversionView(vm: vm.conversionVM)
                    BestRatesView(vm: vm.bestRatesVM)
                    if #available(iOS 16.0, *) {
                        ChartView(vm: vm.chartVM)
                    }
                    ListView(vm: vm.listVM)
                }
            }
            .frame(maxWidth: .infinity)
            .availabilityScrollDismissesKeyboard()
        }
        .background(appearance.theme.backgroundColor)
    }
}

#Preview {
    Assembly.createDashboardView()
}
