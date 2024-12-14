//
//  View+HideKeyboard.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 02.12.2024.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
