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
                VStack {
                    TitleView("Conversion")
                    VStack(alignment: .leading, spacing: 10) {
                        sellSegment(item: item)
                        switchCurrenciesButton()
                        buySegment(item: item)
                        conversionFooter()
                    }
                    .padding()
                    .background(appearance.theme.secondaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }
                .padding()
                .onAppear {
                    setInitialCurrencies(item: item)
                }
                
            } else {
                BasicProgressView()
            }
        }
        .hideKeyboardOnTap()
        .onAppear {
            vm.fetchData()
        }
    }
 
    private func sellSegment(item: ConversionDisplayItem) -> some View {
        HStack {
            sellField(item: item)
            sellPicker(item: item)
                .offset(y: 12)
        }
    }
    
    private func buySegment(item: ConversionDisplayItem) -> some View {
        HStack {
            buyField(item: item)
            buyPicker(item: item)
                .offset(y: 12)
        }
    }
    
    private func sellField(item: ConversionDisplayItem) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(translated("You have"))
                .subHeaderStyle(appearance)
            
            TextField(translated("Amount to sell"), text: $amountToSell)
                .modifier(StandardTextFieldStyle())
                .focused($sellTextFieldFocus)
                .onChange(of: amountToSell) {
                    if !buyTextFieldFocus {
                        updateBuyTextField()
                    }
                }
        }
        .frame(width: 240)
    }
    
    private func buyField(item: ConversionDisplayItem) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(translated("You get"))
                .subHeaderStyle(appearance)
            
            TextField(translated("Amount to buy"), text: $amountToBuy)
                .modifier(StandardTextFieldStyle())
                .focused($buyTextFieldFocus)
                .onChange(of: amountToBuy) {
                    if buyTextFieldFocus {
                        updateSellTextField()
                    }
                }
        }
        .frame(width: 240)
    }
    
    private func sellPicker(item: ConversionDisplayItem) -> some View {
        Picker(translated("Currency"), selection: $currencyToSell) {
            ForEach(item.currencies) { (currency: Currency) in
                if currency != currencyToBuy {
                    Text(currency.name).tag(currency)
                }
            }
        }
        .tint(appearance.theme.actionableColor)
        .modifier(StandardPickerStyle())
        .onChange(of: currencyToSell) {
            updateBuyTextField()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private func buyPicker(item: ConversionDisplayItem) -> some View {
        Picker(translated("Currency"), selection: $currencyToBuy) {
            ForEach(item.currencies) { (currency: Currency) in
                if currency != currencyToSell {
                    Text(currency.name).tag(currency)
                }
            }
        }
        .tint(appearance.theme.actionableColor)
        .modifier(StandardPickerStyle())
        .onChange(of: currencyToBuy) {
            updateBuyTextField()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private func switchCurrenciesButton() -> some View {
        HStack {
            Button {
                (currencyToSell, currencyToBuy) = (currencyToBuy, currencyToSell)
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
        }
        .foregroundStyle(appearance.theme.textColor)
        .opacity(0.8)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, -15)
        .padding(.trailing, 25)
        .offset(y: 17)
    }
    
    private func conversionFooter() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            if let sellAmount = Double(amountToSell),
               sellAmount > 0,
               let buyAmount = Double(amountToBuy),
               let sell = currencyToSell,
               let buy = currencyToBuy {
                
                if isGelConversion() {
                    Text("\(translated("You can sell")) **\(amountToSell)** \(sell.name) \(translated("and get")) **\(amountToBuy)** \(buy.name)")
                } else {
                    Text("\(translated("You can sell")) **\(amountToSell)** \(sell.name) \(translated("and get")) **\(String.formattedDecimal(sellAmount * sell.buy))** \(Currency.CurrencyType.gel.rawValue)")
                    Text("\(translated("Then you can buy")) **\(amountToBuy)** \(buy.name)")
                }
                
                Text("\(translated("Exchange rate")): **1** \(sell.name) = **\(String.formattedDecimal(buyAmount / sellAmount))** \(buy.name) (or **1** \(buy.name) = **\(String.formattedDecimal(sellAmount / buyAmount))** \(sell.name)")
            }
        }
        .font(.footnote)
        .foregroundColor(appearance.theme.secondaryTextColor)
    }
    
    private func isGelConversion() -> Bool {
        return currencyToBuy?.type == Currency.CurrencyType.gel || currencyToSell?.type == Currency.CurrencyType.gel
    }
    
    private func setInitialCurrencies(item: ConversionDisplayItem) {
        if item.currencies.indices.contains(0) {
            currencyToSell = item.currencies[0]
        }
        if item.currencies.indices.contains(1) {
            currencyToBuy = item.currencies[1]
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
    
    struct StandardPickerStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .pickerStyle(MenuPickerStyle())
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

