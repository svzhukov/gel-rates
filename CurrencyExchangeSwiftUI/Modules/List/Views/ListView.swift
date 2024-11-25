//
//  ExchangeList.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation
import SwiftUI

struct ListView: View {
    @ObservedObject var vm: ListVM
    
    init(vm: ListVM) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            if let items = self.vm.listItems {
                ForEach(items) { (item: ListDisplayItem) in
                    VStack {
                        // Header
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.title2)
                                .foregroundColor(.black)
                                .background(
                                    Circle()
                                        .fill(Color.yellow)
                                        .frame(width: 32, height: 32)
                                )
                            
                            Text(item.bank.name.en ?? "No name")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Rates Header
                        HStack {
                            Text("Покупка")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Продажа")
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, -5)
                        
                        // Rates
                        ForEach(item.currencies) { (currency: Currency) in
                            HStack {
                                Text("\(currency.buy, specifier: "%.3f") ₾")
                                    .font(.title3)
                                Spacer()
                                Text(currency.type.flag)
                                    .font(.title3)
                                Spacer()
                                Text("\(currency.sell, specifier: "%.3f") ₾")
                                    .font(.title3)
                            }
                            .padding(.vertical, -5)
                        }
                    }
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            vm.fetchData()
        }
    }
}

#Preview {
    AppAssembly.createListView()
}
