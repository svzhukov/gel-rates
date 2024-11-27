//
//  ContentView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

struct DashboardView: View {
    var vm: ChartVM
    
    init(vm: ChartVM) {
        self.vm = vm
    }
    
    var body: some View {
        NavigationSplitView {
            
            ZStack() {
                Color(hex: "#F1F2EB").ignoresSafeArea()
                ScrollView(.vertical) {
                    VStack {
                        LanguageSwitchView()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding()
                        BestRatesView()
                            .padding(.bottom, 15)
                        NavigationLink {
                            ChartView(vm: self.vm)
                        } label: {
                            Text(translated("USD to GEL currency chart"))
                        }
                        .padding(.bottom, 15)
                        NavigationLink {
                            AppAssembly.createListView()
                        } label: {
                            Text(translated("All banks"))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        } detail: {
            
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
    AppAssembly.createDashboardView()
}
