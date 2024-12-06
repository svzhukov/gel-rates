//
//  View+asd.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 06.12.2024.
//

import SwiftUI

extension View {
    func conditionalOnChange<T>(
        of value: T,
        action: @escaping () -> Void
    ) -> some View where T: Equatable {
        if #available(iOS 17.0, *) {
            print("onChange iOS 17")
            return self.onChange(of: value, initial: false, action)
        } else {
            print("onChange older iOS")
            return self.onChange(of: value) { _ in
                action()
            }
        }
    }
}
