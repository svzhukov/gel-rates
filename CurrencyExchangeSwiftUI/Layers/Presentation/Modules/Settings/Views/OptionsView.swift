//
//  CitySelectionView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 04.12.2024.
//

import SwiftUI


struct OptionsView: View {
    @EnvironmentObject var state: AppState
    @State var collapsed = true
    
    var body: some View {
        Group {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        ThemeSwitcherView()
                        LanguageSwitcherView()
                    }
                    .padding(.horizontal).padding(.bottom)
                    currenciesView()
                    citiesView()
                    optionsView()
                }
                .opacity(collapsed ? 0 : 1)
                .offset(y: collapsed ? -100 : 0)
                .frame(maxHeight: collapsed ? .zero : .infinity)
                
                cogWheelView()
            }
            .foregroundStyle(state.theme.actionableColor)
            .animation(.default, value: collapsed)
        }
        .clipped()
        .padding(.vertical, collapsed ? -20 : 0)
    }
    
    private func citiesView() -> some View {
        VStack {
            HStack {
                ForEach(Constants.City.allCases, id: \.self) { city in
                    Button {
                        state.setCity(city)
                    } label: {
                        Text(translated(city.rawValue))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .foregroundStyle(city == state.selectedCity ? .white : state.theme.actionableColor)
                            .background(city == state.selectedCity ? state.theme.actionableColor : .clear)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.Styles.cornerRadius))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
    
    private func optionsView() -> some View {
        VStack {
            optionButton(icon: state.includeOnline ? "checkmark.square.fill" : "square", text: "Include online banks") {
                state.toggleIncludeOnline()
            }
            
            optionButton(icon: state.workingAvailability == Constants.Options.Availability.all ? "square" : "checkmark.square.fill", text: "Only working now") {
                state.setWorkingAvailability(availability: state.workingAvailability == Constants.Options.Availability.all ? Constants.Options.Availability.availableNowIncludeUnknown : Constants.Options.Availability.all)

            }
            
            if state.workingAvailability != Constants.Options.Availability.all {
                optionButton(icon: state.workingAvailability == Constants.Options.Availability.availableNowIncludeUnknown ? "checkmark.square.fill" : "square", text: "Include unknown schedule") {
                    state.setWorkingAvailability(availability: state.workingAvailability == Constants.Options.Availability.availableNowIncludeUnknown ? Constants.Options.Availability.availableNow : Constants.Options.Availability.availableNowIncludeUnknown)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func optionButton(icon: String, text: String, action: (@escaping @MainActor () -> Void)) -> some View {
        Button {
            action()
        } label: {
            HStack {
                withAnimation {
                    Image(systemName: icon)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text(translated(text))
                    .font(.callout)
                    .foregroundStyle(state.theme.textColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func currenciesView() -> some View {
        ForEach(currencyRows(), id: \.self) { array in
            HStack {
                ForEach(array, id: \.self) { (currency: Constants.CurrencyType) in
                    HStack {
                        Button {
                            var updatedCurrencies = state.selectedCurrencies
                            if let index = updatedCurrencies.firstIndex(of: currency) {
                                updatedCurrencies.remove(at: index)
                            } else {
                                updatedCurrencies.append(currency)
                            }
                            state.setSelectedCurrencies(updatedCurrencies)
                        } label: {
                            Image(systemName: state.selectedCurrencies.contains(currency) ? "checkmark.square.fill" : "square")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(currency.rawValue)
                                .foregroundStyle(state.theme.textColor)
                        }
                        .disabled(shouldBeDisabled(currency))
                    }
                    .foregroundStyle(shouldBeDisabled(currency) ? state.theme.secondaryTextColor : state.theme.actionableColor)
                    .frame(minWidth: 66, alignment: .leading)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func shouldBeDisabled(_ currency: Constants.CurrencyType) -> Bool {
        return currency == Constants.CurrencyType.gel || (state.selectedCurrencies.count <= 2 && state.selectedCurrencies.contains(currency))
    }
    
    private func cogWheelView() -> some View {
        HStack {
            Button {
                withAnimation {
                    collapsed.toggle()
                }
            } label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(state.theme.secondaryTextColor)
                    .rotationEffect(.degrees(collapsed ? 0 : -180))
                Image(systemName: "chevron.down")
                    .foregroundStyle(state.theme.textColor)
                    .opacity(0.8)
                    .rotationEffect(.degrees(collapsed ? 0 : -180))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top)
        .padding(.trailing)
    }
    
    private func currencyRows() -> [[Constants.CurrencyType]] {
        let currencies = Constants.CurrencyType.allCases
        let chunkSize = 5

        let chunkedArrays = stride(from: 0, to: currencies.count, by: chunkSize).map {
            Array(currencies[$0..<min($0 + chunkSize, currencies.count)])
        }
        
        return chunkedArrays
    }
}

#Preview("City") {
    ScrollView(.vertical) {
        OptionsView()
            .environmentObject(AppState.shared)
    }
}

