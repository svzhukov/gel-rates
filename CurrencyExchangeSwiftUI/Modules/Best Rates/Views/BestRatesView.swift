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
                    Text(vm.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(appearance.theme.secondaryTextColor)
                        .padding(.leading, 30)
                        .padding(.bottom, -5)
                    
                    Grid(verticalSpacing: 0) {
                        GridRow {
                            ForEach(vm.headers, id: \.self) { header in
                                Text(header)
                                    .font(.headline)
                                    .foregroundStyle(appearance.theme.textColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(5)
                            }
                        }
                        Divider()
                        ForEach(items) { (item: BestRatesDisplayItem) in
                            GridRow {
                                Text(item.currency.name)
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundStyle(appearance.theme.textColor)
                                    .padding(4)
                                Text("\(item.currency.buy, specifier: "%.3f") ₾")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundStyle(appearance.theme.textColor)
                                    .padding(4)
                                Text("\(item.currency.sell, specifier: "%.3f") ₾")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundStyle(appearance.theme.textColor)
                                    .padding(4)
                            }
                        }
                        
                    }
                    .background(appearance.theme.secondaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }
                .padding(.leading)
                .padding(.trailing)
                
            } else {
                BasicProgressView()
            }
        }
        .onAppear {
            vm.fetchData()
        }
    }
}

#Preview("Dashboard") {
    Assembly.createDashboardView()
}
