//
//  ExchangeRatesView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.10.2024.
//

import Foundation
import SwiftUI

struct BestRatesView: View {
    @ObservedObject var state = AppState.shared
    @ObservedObject var vm: BestRatesVM
    
    var body: some View {
        Group {
            if let items = self.vm.items {
                VStack {
                    TitleView(translated(vm.title))
                    HStack(spacing: 0) {
                        ForEach(Array(vm.headers.enumerated()), id: \.element) { index, header in
                            VStack(spacing: 0) {
                                Text(translated(header))
                                    .subHeaderStyle(state)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 12)
                                
                                Divider()
                                    .background(state.theme.secondaryTextColor)
                                    .padding(.bottom, 4)
                                
                                ForEach(items) { item in
                                    Text(columnText(item: item, for: ColumType(rawValue: index)!))
                                        .bodyStyle(state)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 2)
                                }
                            }
                        }
                    }
                    .padding(.horizontal).padding(.bottom, 4)
                    .background(state.theme.secondaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.Styles.cornerRadius))
                    
                    NavigationLink(destination:
                                    Assembly.createListView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: BackButton())) {
                            HStack {
                                Text(translated("List all organizations"))
                                Image(systemName: "chevron.right")
                            }
                        }
                }
                .padding()
                .onChangeConditional(of: state.selectedCurrencies) {
                    
                }
                
            } else {
                BasicProgressView()
            }
        }
        .onAppear {
            vm.fetchData()
        }
    }
    
    private func backButton() -> some View {
        Button {
            
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text(translated("Back"))
            }
        }
    }
    
    private func columnText(item: BestRatesDisplayItem, for columnType: ColumType) -> String {
        switch columnType {
        case .currency:
            return item.currency.name
        case .buy:
            return "\(String.formattedDecimal(item.currency.buy, maximumFractionDigits: 4))"
        case .sell:
            return "\(String.formattedDecimal(item.currency.sell, maximumFractionDigits: 4))"
        }
    }
    
    private enum ColumType: Int {
        case currency = 0
        case buy = 1
        case sell = 2
    }
}

#Preview("Dashboard") {
    Assembly.createDashboardView()
}
