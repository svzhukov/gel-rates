//
//  ConversionView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 01.12.2024.
//

import SwiftUI

struct ConversionView: View {
    @EnvironmentObject var state: AppState
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
                    .roundedCardStyle(state)
                }
                .padding()
                .onChangeConditional(of: vm.item) {
                    if let item = vm.item {
                        updateCurrencyTypes(item: item)
                        updateBuyTextField(item: item)
                    }
                }
                .onAppear {
                    updateBuyTextField(item: item)
                }
                
            } else {
                BasicProgressView()
            }
        }
        .hideKeyboardOnTap()
        .onAppear {
            if vm.item == nil { vm.fetchData() }
        }
    }
 
    private func sellSegment(item: ConversionDisplayItem) -> some View {
        HStack {
            sellField(item: item)
            sellPicker(item: item)
        }
    }
    
    private func buySegment(item: ConversionDisplayItem) -> some View {
        HStack {
            buyField(item: item)
            buyPicker(item: item)
        }
    }
    
    private func sellField(item: ConversionDisplayItem) -> some View {
        field(item: item, header: "You have", placeholder: "Amount to buy", text: $amountToSell, focus: $sellTextFieldFocus, onChangeOf: amountToSell) {
            if !buyTextFieldFocus {
                updateBuyTextField(item: item)
            }
        }
    }
    
    private func buyField(item: ConversionDisplayItem) -> some View {
        field(item: item, header: "You get", placeholder: "Amount to buy", text: $amountToBuy, focus: $buyTextFieldFocus, onChangeOf: amountToBuy) {
            if buyTextFieldFocus {
                updateSellTextField(item: item)
            }
        }
    }
    
    private func sellPicker(item: ConversionDisplayItem) -> some View {
        picker(item: item, selection: $sellCurrencyType, onChangeCurrencyType: sellCurrencyType, ignoreCurrencyType: buyCurrencyType)
    }
    
    private func buyPicker(item: ConversionDisplayItem) -> some View {
        picker(item: item, selection: $buyCurrencyType, onChangeCurrencyType: buyCurrencyType, ignoreCurrencyType: sellCurrencyType)
    }
    
    private func picker(item: ConversionDisplayItem, selection: Binding<Constants.CurrencyType>, onChangeCurrencyType: Constants.CurrencyType, ignoreCurrencyType: Constants.CurrencyType) -> some View {
        Picker(translated("Currency"), selection: selection) {
            ForEach(item.currencies) { (currency: Currency) in
                if currency.type != ignoreCurrencyType {
                    Text(currency.name).tag(currency.type)
                }
            }
        }
        .tint(state.theme.actionableColor)
        .modifier(StandardPickerStyle())
        .frame(maxWidth: .infinity, alignment: .center)
        .offset(y: 12)
        .onChangeConditional(of: onChangeCurrencyType) {
            updateBuyTextField(item: item)
        }
    }
    
    private func field(item: ConversionDisplayItem, header: String, placeholder: String, text: Binding<String>, focus: FocusState<Bool>.Binding, onChangeOf: String, action: (@escaping () -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(translated(header))
                .subHeaderStyle(state)
            
            TextField(translated(placeholder), text: text)
                .modifier(StandardTextFieldStyle())
                .focused(focus)
                .onChangeConditional(of: onChangeOf) {
                    action()
                }
        }
        .frame(width: 240)
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
        .padding(.trailing, 30)
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
                
                Text("\(translated("Exchange rate")): **1** \(sellCurrencyType.rawValue) = **\(String.formattedDecimal(buyAmount / sellAmount))** \(buyCurrencyType.rawValue) (\(translated("or")) **1** \(buyCurrencyType.rawValue) = **\(String.formattedDecimal(sellAmount / buyAmount))** \(sellCurrencyType.rawValue)")
            }
        }
        .font(.footnote)
        .foregroundColor(state.theme.secondaryTextColor)
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
    
    private func updateCurrencyTypes(item: ConversionDisplayItem) {
        sellCurrencyType = item.currencies[0].type
        buyCurrencyType = item.currencies[1].type
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
}

#Preview {
    Assembly.createDashboardView()
}

