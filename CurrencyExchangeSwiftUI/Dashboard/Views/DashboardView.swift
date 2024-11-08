//
//  ContentView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 13.09.2024.
//

import SwiftUI

struct DashboardView: View {
    var vm: DashboardViewModel
    
    init(vm: DashboardViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        ZStack() {
            Color(hex: "#F1F2EB").ignoresSafeArea()
            ScrollView(.vertical) {
                VStack {
                    HStack(alignment: .bottom) {
                        Image("GEL")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.bottom, 3)
                        Text("Exchange Rates")
                            .font(.title)
                            .padding(.bottom, 0)
                    }
                    .padding(.bottom, 15)
                    
                    ExchangeRateView()
                        .padding(.bottom, 15)
                    ExchangeGraphView(vm: self.vm)
                }
            }
        }
    }
}

#Preview {
    AppAssembly.createDashboardView()
}
