//
//  Themes.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 28.11.2024.
//

import SwiftUI

class Appearance: ObservableObject {
    static var shared = Appearance()
    private init() {}

    @Published private(set) var theme: Constants.Theme = StorageManager.shared.loadAppTheme() ?? .light
    
    func setTheme(_ newTheme: Constants.Theme) {
        theme = newTheme
        StorageManager.shared.saveAppTheme(to: theme)
        print("Set theme: \(newTheme)")
    }
    
    func toggleTheme() {
        setTheme(theme == .dark ? .light : .dark)
    }
}

