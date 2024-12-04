//
//  ExchangeList.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation
import SwiftUI

struct ListView: View {
    @ObservedObject var appearance = Appearance.shared
    @ObservedObject var vm: ListVM
    
    init(vm: ListVM) {
        self.vm = vm
    }
    
    var body: some View {
        Group {
            if let items = self.vm.listItems {
                VStack {
                    TitleView(translated("List of exchangers"))
                    ForEach(items) { (item: ListDisplayItem) in
                        VStack {
                            listHeaderView(item)
                            listContentView(item)
                        }
                        .padding()
                        .background(appearance.theme.secondaryBackgroundColor)
                        .cornerRadius(Constants.cornerRadius)
                    }
                }
                .padding()

            } else {
                BasicProgressView()
            }
        }
        .onAppear {
            vm.fetchData()
        }
    }
    
    private func listHeaderView(_ item: ListDisplayItem) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .frame(width: 38, height: 38)
                .foregroundStyle(.white)
                .shadow(color: .white, radius: 2)
                .overlay(
                    Image(item.bank.icon.name)
                    .if(item.bank.icon.fileExtension == "png") { view in
                        view
                            .resizable()
                            .frame(maxWidth: 32, maxHeight: 32)
                    }
                        .frame(maxWidth: 32, maxHeight: 32)
                        .scaledToFit()
                )


            Text(item.bank.name.en!)
                .headlineStyle(appearance)
            
            if item.bank.type == Bank.OrgType.online {
                Image(systemName: "iphone.gen1")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
    
    private func listContentView(_ item: ListDisplayItem) -> some View {
        Group {
            HStack {
                Text(translated("list_header_buy"))
                Spacer()
                Text(translated("list_header_sell"))
            }
            .subHeaderStyle(appearance)
            .padding(.bottom, 3)
            
            ForEach(item.bank.currencies) { (currency: Currency) in
                HStack {
                    Text("\(currency.buy, specifier: "%.3f") \(Currency.CurrencyType.gel.symbol)")
                        .if(currency.buy == currency.buyBest) { view in
                            view
                                .foregroundStyle(appearance.theme.accentColor)
                        }
                        .frame(maxWidth: 100, alignment: .leading)
                    Spacer()
                    Text("\(currency.type.flag)  1 \(currency.type.symbol)")
                        .font(.body).bold()
                        .frame(alignment: .leading)
                    Spacer()
                    Text("\(currency.sell, specifier: "%.3f") \(Currency.CurrencyType.gel.symbol)")
                        .if(currency.sell == currency.sellBest) { view in
                            view
                                .foregroundStyle(appearance.theme.accentColor)
                        }
                        .frame(maxWidth: 100, alignment: .trailing)
                }
                .bodyStyle(appearance)
            }
        }
    }
}

#Preview("List") {
    ScrollView {
        Assembly.createListView()
    }
}

#Preview("Dashboard") {
    Assembly.createDashboardView()
}
