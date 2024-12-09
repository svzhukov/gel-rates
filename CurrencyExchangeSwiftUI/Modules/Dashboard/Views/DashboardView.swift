//
//  ContentView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var state: AppState
    @StateObject private var vm: DashboardVM
    
    init(dashboardVM: DashboardVM) {
        _vm = StateObject(wrappedValue: dashboardVM)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
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
            .background(state.theme.backgroundColor)
        }
        .preferredColorSchemeConditional(scheme: state.theme.colorSceme)
    }
    
    private func title() -> some View {
        Text(vm.title)
            .titleStyle(state)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal).padding(.top)
            .onChangeConditional(of: state.selectedCity) {
                vm.updateTitle()
            }
            .onChangeConditional(of: state.language) {
                vm.updateTitle()
            }
    }
}

#Preview {
    Assembly.createDashboardView()
}
