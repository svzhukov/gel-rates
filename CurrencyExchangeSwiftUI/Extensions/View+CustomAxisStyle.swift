//
//  View+CustomAxisStyle.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.11.2024.
//

import SwiftUI

extension View {
    func customAxisStyle(textColor: Color) -> some View {
        self.modifier(CustomAxisStyle(textColor: textColor))
    }
}
