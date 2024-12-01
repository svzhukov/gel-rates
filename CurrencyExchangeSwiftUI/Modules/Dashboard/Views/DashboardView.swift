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
                        
                        BestRatesView(vm: vm.bestRatesVM)                        
                        ChartView(vm: vm.chartVM)
                        ListView(vm: vm.listVM)
                           

//                        NavigationLink {
//                            Assembly.createChartView()
//                        } label: {
//                            Text(translated("USD to GEL currency chart"))
//                        }
//                        .padding(.bottom, 15)
//                        NavigationLink {
//                            Assembly.createListView()
//                        } label: {
//                            Text(translated("All banks"))
//                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
    }
}

struct TitleView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            Image("GEL")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.bottom, 3)
            Text("Exchange Rates")
                .font(.title)
                .padding(.bottom, 0)
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
