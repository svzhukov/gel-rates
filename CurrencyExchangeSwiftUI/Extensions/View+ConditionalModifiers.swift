//
//  View+ConditionalModifiers.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 26.11.2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
