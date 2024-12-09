//
//  ExchangeRatesView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.10.2024.
//

import Foundation
import SwiftUI

struct BestRatesView: View {
    @EnvironmentObject var state: AppState
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
                    .roundedCardStyle(state)
                    
                    NavigationLink(destination:
                                    Assembly.createListView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: BackButton())) {
                            HStack {
                                Text(translated("View all organizations"))
                                Image(systemName: "chevron.right")
                            }
                        }
                }
                .padding()
                
            } else {
                BasicProgressView()
            }
        }
        .onAppear {
            if vm.items == nil { vm.fetchData() }
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
        case .name:
            return item.currency.name
        case .buy:
            return "\(String.formattedDecimal(item.currency.buy, maximumFractionDigits: 4))"
        case .sell:
            return "\(String.formattedDecimal(item.currency.sell, maximumFractionDigits: 4))"
        }
    }
    
    private enum ColumType: Int {
        case name = 0
        case buy = 1
        case sell = 2
    }
}

#Preview("Dashboard") {
    Assembly.createDashboardView()
}
