//
//  View+Styles.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 06.12.2024.
//

import SwiftUI
import Charts

extension View {
    func subHeaderStyle(_ state: AppState) -> some View {
        self
            .font(.body)
            .foregroundStyle(state.theme.secondaryTextColor)
    }
    
    func headerStyle(_ state: AppState) -> some View {
        self
            .font(.title3)
            .foregroundStyle(state.theme.secondaryTextColor)
    }
    
    func bodyStyle(_ state: AppState) -> some View {
        self
            .font(.body)
            .foregroundStyle(state.theme.textColor)
    }
    
    func headlineStyle(_ state: AppState) -> some View {
        self
            .font(.headline)
            .foregroundStyle(state.theme.textColor)
    }
    
    func titleStyle(_ state: AppState) -> some View {
        self
            .font(.title2)
            .foregroundStyle(state.theme.textColor)
    }
    
    func axisStyle(_ state: AppState) -> some View {
        self
            .foregroundStyle(state.theme.secondaryTextColor)
            .font(.system(size: 8))
    }
    
    func roundedCardStyle(_ state: AppState) -> some View {
        self
            .background(state.theme.secondaryBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Styles.cornerRadius))
    }
    
    func iconStyle(_ state: AppState) -> some View {
        self
            .foregroundStyle(state.theme.secondaryTextColor)
            .font(.system(size: 16, weight: .bold))
    }
}

