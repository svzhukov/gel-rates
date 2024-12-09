//
//  ExchangeList.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation
import SwiftUI

struct ListView: View {
    @ObservedObject var state = AppState.shared
    @ObservedObject var vm: ListVM
    
    init(vm: ListVM) {
        self.vm = vm
    }
    
    var body: some View {
        Group {
            if let items = self.vm.listItems {
                ScrollView {
                    VStack {
                        TitleView(translated("List of organizations"))
                        ForEach(items.filter { $0.bank.currencies.count > 0 }) { (item: ListDisplayItem) in
                            VStack {
                                listHeaderView(item)
                                listContentView(item)
                            }
                            .padding()
                            .roundedCardStyle(state)
                        }
                    }
                    .padding()
                }
                .background(state.theme.backgroundColor)

            } else {
                BasicProgressView()
            }
        }
        .onAppear {
            if vm.listItems == nil { vm.fetchData() }
        }
    }
    
    private func listHeaderView(_ item: ListDisplayItem) -> some View {
        HStack {
            orgImageView(item)
            
            Text(item.bank.name.en!)
                .headlineStyle(state)
            
            if item.bank.type == Bank.OrgType.online {
                Image(systemName: "iphone")
                    .iconStyle(state)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
    
    private func orgImageView(_ item: ListDisplayItem) -> some View {
        RoundedRectangle(cornerRadius: Constants.Styles.cornerRadius)
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
    }
    
    private func listContentView(_ item: ListDisplayItem) -> some View {
        Group {
            HStack {
                Text(translated("Buy"))
                Spacer()
                Text(translated("Sell"))
            }
            .subHeaderStyle(state)
            .padding(.bottom, 3)
            
            ForEach(item.bank.currencies) { (currency: Currency) in
                HStack {
                    Text("\(String.formattedDecimal(currency.buy, maximumFractionDigits: 4)) \(Constants.CurrencyType.gel.symbol)")
                        .if(currency.buy == item.best.currency(for: currency.type)?.buy) { view in
                            view
                                .foregroundStyle(state.theme.accentColor)
                        }
                        .frame(maxWidth: 100, alignment: .leading)
                    Spacer()
                    Text("\(currency.type.flag)  1 \(currency.type.symbol)")
                        .font(.body).bold()
                        .frame(alignment: .leading)
                    Spacer()
                    Text("\(String.formattedDecimal(currency.sell, maximumFractionDigits: 4)) \(Constants.CurrencyType.gel.symbol)")
                        .if(currency.sell == item.best.currency(for: currency.type)?.sell) { view in
                            view
                                .foregroundStyle(state.theme.accentColor)
                        }
                        .frame(maxWidth: 100, alignment: .trailing)
                }
                .bodyStyle(state)
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
