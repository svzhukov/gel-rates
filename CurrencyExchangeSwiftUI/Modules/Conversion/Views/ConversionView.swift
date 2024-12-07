//
//  ConversionView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import SwiftUI

struct ConversionView: View {
    @ObservedObject var state = AppState.shared
    @ObservedObject var vm: ConversionVM

    @FocusState private var sellTextFieldFocus: Bool
    @FocusState private var buyTextFieldFocus: Bool
    
    @State private var amountToSell: String = "100"
    @State private var amountToBuy: String = ""
    @State private var sellCurrencyType: Constants.CurrencyType = AppState.shared.selectedCurrencies[0]
    @State private var buyCurrencyType: Constants.CurrencyType = AppState.shared.selectedCurrencies[1]
    
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
                        conversionFooter(item: item)
                    }
                    .padding()
                    .background(state.theme.secondaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Styles.cornerRadius))
                }
                .padding()
                
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
                .subHeaderStyle(state)
            
            TextField(translated("Amount to sell"), text: $amountToSell)
                .modifier(StandardTextFieldStyle())
                .focused($sellTextFieldFocus)
                .onChangeConditional(of: amountToSell) {
                    if !buyTextFieldFocus {
                        updateBuyTextField(item: item)
                    }
                }
        }
        .frame(width: 240)
    }
    
    private func buyField(item: ConversionDisplayItem) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(translated("You get"))
                .subHeaderStyle(state)
            
            TextField(translated("Amount to buy"), text: $amountToBuy)
                .modifier(StandardTextFieldStyle())
                .focused($buyTextFieldFocus)
                .onChangeConditional(of: amountToBuy) {
                    if buyTextFieldFocus {
                        updateSellTextField(item: item)
                    }
                }
        }
        .frame(width: 240)
    }
    
    private func sellPicker(item: ConversionDisplayItem) -> some View {
        Picker(translated("Currency"), selection: $sellCurrencyType) {
            ForEach(item.currencies) { (currency: Currency) in
                if currency.type != buyCurrencyType {
                    Text(currency.name).tag(currency.type)
                }
            }
        }
        .tint(state.theme.actionableColor)
        .modifier(StandardPickerStyle())
        .onChangeConditional(of: sellCurrencyType) {
            updateBuyTextField(item: item)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private func buyPicker(item: ConversionDisplayItem) -> some View {
        Picker(translated("Currency"), selection: $buyCurrencyType) {
            ForEach(item.currencies) { (currency: Currency) in
                if currency.type != sellCurrencyType {
                    Text(currency.name).tag(currency.type)
                }
            }
        }
        .tint(state.theme.actionableColor)
        .modifier(StandardPickerStyle())
        .onChangeConditional(of: buyCurrencyType) {
            updateBuyTextField(item: item)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private func switchCurrenciesButton() -> some View {
        HStack {
            Button {
                (sellCurrencyType, buyCurrencyType) = (buyCurrencyType, sellCurrencyType)
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
        }
        .foregroundStyle(state.theme.textColor)
        .opacity(0.8)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.vertical, -15)
        .padding(.trailing, 25)
        .offset(y: 17)
    }
        
    private func conversionFooter(item: ConversionDisplayItem) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            if let sellAmount = Double(amountToSell),
               sellAmount > 0,
               let buyAmount = Double(amountToBuy),
               let currencyToSell = item.currencies.currency(for: sellCurrencyType){
                if isGelConversion() {
                    Text("\(translated("You can sell")) **\(amountToSell)** \(sellCurrencyType.rawValue) \(translated("and get")) **\(amountToBuy)** \(buyCurrencyType.rawValue)")
                } else {
                    Text("\(translated("You can sell")) **\(amountToSell)** \(sellCurrencyType.rawValue) \(translated("and get")) **\(String.formattedDecimal(sellAmount * currencyToSell.buy))** \(Constants.CurrencyType.gel.rawValue)")
                    Text("\(translated("Then you can buy")) **\(amountToBuy)** \(buyCurrencyType.rawValue)")
                }
                
                Text("\(translated("Exchange rate")): **1** \(sellCurrencyType.rawValue) = **\(String.formattedDecimal(buyAmount / sellAmount))** \(buyCurrencyType.rawValue) (or **1** \(buyCurrencyType.rawValue) = **\(String.formattedDecimal(sellAmount / buyAmount))** \(sellCurrencyType.rawValue)")
            }
        }
        .font(.footnote)
        .foregroundColor(state.theme.secondaryTextColor)
    }
    
    private func isGelConversion() -> Bool {
        return buyCurrencyType == Constants.CurrencyType.gel || sellCurrencyType == Constants.CurrencyType.gel
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
    
    private func updateSellTextField(item: ConversionDisplayItem) {
        let amount = Double(amountToBuy) ?? 0
        if let currencyToSell = item.currencies.currency(for: sellCurrencyType), let currencyToBuy = item.currencies.currency(for: buyCurrencyType) {
            amountToSell = String.formattedDecimal(amount * currencyToBuy.sell / currencyToSell.buy)
        }
    }
    
    private func updateBuyTextField(item: ConversionDisplayItem) {
        let amount = Double(amountToSell) ?? 0
        if let currencyToSell = item.currencies.currency(for: sellCurrencyType), let currencyToBuy = item.currencies.currency(for: buyCurrencyType) {
            amountToBuy = String.formattedDecimal(amount * currencyToSell.buy / currencyToBuy.sell)
        }
    }
}

#Preview {
    Assembly.createDashboardView()
}

