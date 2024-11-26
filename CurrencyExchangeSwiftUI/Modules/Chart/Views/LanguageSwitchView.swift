//
//  LanguageSwitch.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 26.11.2024.
//

import SwiftUI

struct LanguageSwitchView: View {
    
    let activeLang: String = "eng"
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "globe")
                .foregroundStyle(.teal)
            
            HStack(spacing: 0) {
                ForEach(["ru", "eng"], id: \.self) { lang in
                    Text(lang)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(lang == activeLang ? .white : .secondary)
                        .frame(width: 48, height: 30, alignment: .center)
                        .background(lang == activeLang ? Color.gray.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    
                    if lang == "ru" {
                        Divider()
                            .frame(width: 3, height: 25)
                            .background(Color.gray)
                            .opacity(0.5)
                    }
                }
            }
            .background(Color(hex: "d8dad3"))
            .cornerRadius(12)
        }
    }
}

#Preview {
    LanguageSwitchView()
}
