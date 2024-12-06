//
//  ChartButtonsView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.11.2024.
//

import SwiftUI

struct ChartButtonsView: View {
    @ObservedObject var state = AppState.shared
    @ObservedObject var vm: ChartVM
    
    init(vm: ChartVM) {
        self.vm = vm
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(TimeRange.allCases) { range in
                Button(action: {
                    self.vm.selectedTimeRange = range
                }) {
                    Text(range.localizedName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(range == self.vm.selectedTimeRange ? state.theme.textColor : state.theme.secondaryTextColor)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(range == self.vm.selectedTimeRange ? state.theme.secondaryBackgroundColor : Color.clear)
                        .cornerRadius(Constants.cornerRadius)
                }
            }
        }
        .background(state.theme.secondaryBackgroundColor)
        .cornerRadius(Constants.cornerRadius)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    Assembly.createDashboardView()
}
