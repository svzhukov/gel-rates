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
                Color(appearance.theme.backgroundColor).ignoresSafeArea()
                ScrollView(.vertical) {
                    VStack {
                        HStack {
                            ThemeSwitcherView()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            LanguageSwitcherView()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        
//                        ConversionView(vm: vm.conversionVM)
                        BestRatesView(vm: vm.bestRatesVM)
//                        ChartView(vm: vm.chartVM)
                        ListView(vm: vm.listVM)
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollDismissesKeyboard(.immediately)
            }
    }
}

struct NavigationView: View {
    var body: some View {
        NavigationStack { // Use NavigationView for iOS 15 or earlier
            VStack {
                Text("Home Screen")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink("Go to Details", destination: DetailView())
                    .padding()
                    .font(.headline)
            }
            .navigationTitle("Home")
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Details Screen")
            .font(.largeTitle)
            .navigationTitle("Details")
    }
}

#Preview {
    Assembly.createDashboardView()
}
