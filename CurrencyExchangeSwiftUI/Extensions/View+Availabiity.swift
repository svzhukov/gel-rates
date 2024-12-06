//
//  View+asd.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 06.12.2024.
//

import SwiftUI

extension View {
    func availabilityOnChange<T>(
        of value: T,
        action: @escaping () -> Void
    ) -> some View where T: Equatable {
        if #available(iOS 17.0, *) {
            return self.onChange(of: value, initial: false, action)
        } else {
            return self.onChange(of: value) { newValue in
                action()
            }
        }
    }
}

extension View {
    func availabilityScrollDismissesKeyboard() -> some View {
        if #available(iOS 17.0, *) {
            return self.scrollDismissesKeyboard(.immediately)
        } else {
            return self.simultaneousGesture(DragGesture().onChanged({ _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }))
        }
    }
}
