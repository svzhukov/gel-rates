//
//  ConversionView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import SwiftUI

struct ConversionView: View {
    @ObservedObject var appearance = Appearance.shared
    @ObservedObject var vm: ConversionVM

    @FocusState private var sellTextFieldFocus: Bool
    @FocusState private var buyTextFieldFocus: Bool
    
    @State private var amountToSell: String = "100"
    @State private var amountToBuy: String = ""
    @State private var currencyToSell: Currency?
    @State private var currencyToBuy: Currency?
    
    init(vm: ConversionVM) {
        self.vm = vm
    }
    
    var body: some View {
        Group {
            if let item = vm.item {
                VStack(alignment: .leading, spacing: 10) {
                    sellSegment(item: item)
                    buySegment(item: item)
                    conversionFooter()
                }
                .padding()
                .background(appearance.theme.secondaryBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                .padding()
                
            } else {
                ProgressView(translated("Loading..."))
            }
        }
        .hideKeyboardOnTap()
        .onAppear {
            vm.fetchData()
        }
    }
    
    private func sellSegment(item: ConversionDisplayItem) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(translated("You have"))
                .foregroundStyle(appearance.theme.secondaryTextColor)
            
            HStack {
                TextField(translated("Amount to sell"), text: $amountToSell)
                    .modifier(StandardTextFieldStyle())
                    .focused($sellTextFieldFocus)
                    .onChange(of: amountToSell) {
                        if !buyTextFieldFocus {
                            updateBuyTextField()
                        }
                    }
                
                Picker(translated("Currency"), selection: $currencyToSell) {
                    ForEach(item.currencies) { (currency: Currency) in
                        Text(currency.name).tag(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100)
                .onChange(of: currencyToSell) {
                    updateBuyTextField()
                }
                .onAppear {
                    if item.currencies.indices.contains(0) {
                        currencyToSell = item.currencies[0]
                    }
                }
            }
        }
    }
    
    private func buySegment(item: ConversionDisplayItem) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(translated("You get"))
                .foregroundStyle(appearance.theme.secondaryTextColor)
            
            HStack {
                TextField(translated("Amount to buy"), text: $amountToBuy)
                    .modifier(StandardTextFieldStyle())
                    .focused($buyTextFieldFocus)
                    .onChange(of: amountToBuy) {
                        if buyTextFieldFocus {
                            updateSellTextField()
                        }
                    }
                
                Picker(translated("Currency"), selection: $currencyToBuy) {
                    ForEach(item.currencies) { (currency: Currency) in
                        Text(currency.name).tag(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100)
                .onChange(of: currencyToBuy) {
                    updateBuyTextField()
                }
                .onAppear {
                    if item.currencies.indices.contains(1) {
                        currencyToBuy = item.currencies[1]
                    }
                }
            }
        }
    }
    
    private func conversionFooter() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let sellAmount = Double(amountToSell),
               sellAmount > 0,
               let buyAmount = Double(amountToBuy),
               let sell = currencyToSell,
               let buy = currencyToBuy {
                Text("\(translated("You can sell")) **\(amountToSell)** \(sell.name) \(translated("and get")) **\(String.formattedDecimal(sellAmount * sell.buy))** \(Currency.CurrencyType.gel.rawValue)")
                    .font(.footnote)
                    .foregroundColor(appearance.theme.secondaryTextColor)
                if currencyToBuy?.type != Currency.CurrencyType.gel {
                    Text("\(translated("Then you can buy")) **\(amountToBuy)** \(buy.name)")
                        .font(.footnote)
                        .foregroundColor(appearance.theme.secondaryTextColor)
                }
                Text("\(translated("Exchange rate:")) **1** \(sell.name) = **\(String.formattedDecimal(buyAmount / sellAmount))** \(buy.name) (or **1** \(buy.name) = **\(String.formattedDecimal(sellAmount / buyAmount))** \(sell.name)")
                    .font(.footnote)
                    .foregroundColor(appearance.theme.secondaryTextColor)
            }
        }
    }
    
    struct StandardTextFieldStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .opacity(0.9)
        }
    }
    
    private func updateSellTextField() {
        let amount = Double(amountToBuy) ?? 0
        amountToSell = String.formattedDecimal(amount * currencyToBuy!.sell / currencyToSell!.buy)
    }
    
    private func updateBuyTextField() {
        let amount = Double(amountToSell) ?? 0
        amountToBuy = String.formattedDecimal(amount * currencyToSell!.buy / currencyToBuy!.sell)
    }
}

#Preview {
    Assembly.createDashboardView()
}

