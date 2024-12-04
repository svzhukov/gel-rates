//
//  ExchangeRatesView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.10.2024.
//

import Foundation
import SwiftUI

struct BestRatesView: View {
    @ObservedObject var appearance = Appearance.shared
    @ObservedObject var vm: BestRatesVM
    
    var body: some View {
        Group {
            if let items = self.vm.items {
                VStack {
                    TitleView(vm.title)
                    Grid(verticalSpacing: 0) {
                        headers(vm.headers)
                        Divider()
                            .background(appearance.theme.secondaryTextColor)
                        content(items)
                    }
                    .background(appearance.theme.secondaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
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
    
    private func headers(_ headers: [String]) -> some View {
        GridRow {
            ForEach(headers, id: \.self) { header in
                Text(header)
                    .subHeaderStyle(appearance)
                    .frame(maxWidth: .infinity)
                    .padding(12)
            }
        }
    }
    
    private func content(_ items: [BestRatesDisplayItem]) -> some View {
        ForEach(items) { (item: BestRatesDisplayItem) in
            GridRow {
                Text(item.currency.name)
                Text("\(item.currency.buy, specifier: "%.3f") \(Currency.CurrencyType.gel.symbol)")
                Text("\(item.currency.sell, specifier: "%.3f") \(Currency.CurrencyType.gel.symbol)")
            }
            .bodyStyle(appearance)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(2)
        }
    }

}

#Preview("Dashboard") {
    Assembly.createDashboardView()
}
