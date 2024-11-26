//
//  LanguageSwitch.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 26.11.2024.
//

import SwiftUI
import Foundation

struct LanguageSwitchView: View {
    
    @State var activeLang: String = "en"
    @State var isHidden: Bool = true
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                isHidden = !isHidden
            }) {
                HStack {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.teal)
                        .animation(.bouncy, value: isHidden)
                    
                    Text(activeLang)
                        .tint(.teal)
                        .frame(width: isHidden ? 30 : 0, alignment: .leading)
                        .animation(nil, value: isHidden)
                }
            }
            .offset(x: isHidden ? 103 : 0)
            .zIndex(1)

            
            HStack(spacing: 0) {
                ForEach(["ru", "en"], id: \.self) { lang in
                    Button(action: {
                        activeLang = lang
                        isHidden = !isHidden
                    }) {
                        Text(lang)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(lang == activeLang ? .white : .secondary)
                            .frame(width: 48, height: 30, alignment: .center)
                            .background(lang == activeLang ? Color.gray.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                    }
                    
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
            .opacity(isHidden ? 0 : 1)
            .animation(isHidden ? .easeOut(duration: 0.2) : .easeIn(duration: 0.2), value: isHidden)
        }
        .frame(height: 30)
    }
}

#Preview {
    LanguageSwitchView()
}
