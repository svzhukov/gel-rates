//
//  CitySelectionView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 04.12.2024.
//

import SwiftUI


struct OptionsView: View {
    
    @State var selectedCity: Constants.City = Constants.City.tbilisi
    @State private var includeOnline = false
    @State private var workingNow = false
    @State private var collapsed = true

    @ObservedObject var appearance = Appearance.shared

    var body: some View {
        Group {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        ThemeSwitcherView()
                        LanguageSwitcherView()
                    }
                    .padding(16)
                    currenciesView()
                    citiesView()
                    optionsView()
                }
                .opacity(collapsed ? 0 : 1)
                .offset(y: collapsed ? -100 : 0)
                .frame(maxHeight: collapsed ? .zero : .infinity)
                
                cogWheelView()
            }
            .foregroundStyle(appearance.theme.actionableColor)
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
                        selectedCity = city
                    } label: {
                        Text(translated(city.rawValue))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .foregroundStyle(city == selectedCity ? .white : appearance.theme.actionableColor)
                            .background(city == selectedCity ? appearance.theme.actionableColor : .clear)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
    
    private func optionsView() -> some View {
        VStack {
            Button {
                includeOnline.toggle()
            } label: {
                HStack {
                    Image(systemName: includeOnline ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(translated("Include online banks"))
                        .font(.callout)
                        .foregroundStyle(appearance.theme.textColor)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button {
                workingNow.toggle()
            } label: {
                HStack {
                    withAnimation {
                        Image(systemName: workingNow ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 20, height: 20)

                    }
                    Text(translated("Only working now"))
                        .font(.callout)
                        .foregroundStyle(appearance.theme.textColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal)
    }
    
    private func currenciesView() -> some View {
        ForEach(currenciesTwoHalfArrays(), id: \.self) { array in
            HStack {
                ForEach(array, id: \.self) { currency in
                    HStack {
                        Button {
                            includeOnline.toggle()
                        } label: {
                            Image(systemName: includeOnline || isGel(currency) ? "checkmark.square.fill" : "square")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(currency.rawValue)
                                .foregroundStyle(appearance.theme.textColor)
                        }
                        .disabled(isGel(currency))
                    }
                    .foregroundStyle(isGel(currency) ? appearance.theme.secondaryTextColor : appearance.theme.actionableColor)
                    .frame(minWidth: 66, alignment: .leading)
                }
            }
            .padding(.horizontal)
        }
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
                    .foregroundStyle(appearance.theme.secondaryTextColor)
                Image(systemName: "chevron.down")
                    .foregroundStyle(appearance.theme.textColor)
                    .opacity(0.8)
                    .rotationEffect(.degrees(collapsed ? 0 : -180))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top)
        .padding(.trailing)
    }
    
    private func isGel(_ curr: Currency.CurrencyType) -> Bool {
        curr == Currency.CurrencyType.gel
    }
    
    private func currenciesTwoHalfArrays() -> [[Currency.CurrencyType]] {
        let currencies = Currency.CurrencyType.allCases
        let midpoint = currencies.count / 2
        return [Array(currencies[..<midpoint]), Array(currencies[midpoint...])]
    }
}

#Preview("City") {
    OptionsView()
}

#Preview("Dashboard") {
    Assembly.createDashboardView()
}
