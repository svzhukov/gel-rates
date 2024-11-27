//
//  Localization.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 27.11.2024.
//

import Foundation

class Localization {
    static let shared = Localization()
    private init() {}
    
    var language: Constants.Language = StorageManager.shared.loadAppLanguage() ?? Constants.Language.defaultLanguage
    var bundle: Bundle {
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        } else {
            return .main
        }
    }
    
    static func initialize() {
        _ = shared
        NotificationCenter.default.post(name: .languageDidSetup, object: nil)
        print("Setup language to: \(shared.language)")
    }
    
    func setLanguage(_ lang: Constants.Language) {
        if lang == language { return }
        language = lang
        StorageManager.shared.saveAppLanguage(to: lang)
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
        print("Set language to: \(lang.rawValue)")
    }
}

func translated(_ key: String, comment: String = "") -> String {
    return NSLocalizedString(key, bundle: Localization.shared.bundle, comment: comment)
}

