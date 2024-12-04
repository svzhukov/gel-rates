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
                        headersView(vm.headers)
                        Divider()
                            .background(appearance.theme.secondaryTextColor)
                            .padding(.bottom, 4)
                            .padding(.horizontal, 10)
                        contentView(items)
                    }
                    .padding(.bottom, 4)
                    .background(appearance.theme.secondaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }
                .frame(alignment: .center)
                .padding()
                
            } else {
                BasicProgressView()
            }
        }
        .onAppear {
            vm.fetchData()
        }
    }
    
    private func headersView(_ headers: [String]) -> some View {
        GridRow {
            ForEach(headers, id: \.self) { header in
                Text(header)
                    .subHeaderStyle(appearance)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.leading, 20)
            }
        }
    }
    
    private func contentView(_ items: [BestRatesDisplayItem]) -> some View {
        Group {
            ForEach(items) { (item: BestRatesDisplayItem) in
                GridRow {
                    Text(item.currency.name)
                    Text("\(String.formattedDecimal(item.currency.buy, maximumFractionDigits: 4))")
                    Text("\(String.formattedDecimal(item.currency.sell, maximumFractionDigits: 4))")
                }
                .bodyStyle(appearance)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 2)
                .padding(.leading, 20)
            }
        }
    }
}

#Preview("Dashboard") {
    Assembly.createDashboardView()
}
