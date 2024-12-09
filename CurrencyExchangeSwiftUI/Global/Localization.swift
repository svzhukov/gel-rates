//
//  Localization.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 09.12.2024.
//

import Foundation

struct Localization {
    static let shared = Localization()
    private init() {}

    var bundle: Bundle {
        if let path = Bundle.main.path(forResource: AppState.shared.language.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        } else {
            return .main
        }
    }
}

func translated(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, bundle: Localization.shared.bundle, comment: comment)
}

