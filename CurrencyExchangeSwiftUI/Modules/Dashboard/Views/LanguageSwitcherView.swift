//
//  LanguageSwitch.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 26.11.2024.
//

import SwiftUI
import Foundation

struct LanguageSwitcherView: View {
    @State var activeLang: Constants.Language = Localization.shared.language
    @State var isHidden: Bool = true
        
    var body: some View {
        HStack(spacing: 0) {
            LanguagesButtonView(activeLang: $activeLang, isHidden: $isHidden)
            LanguagesPanelView(activeLang: $activeLang, isHidden: $isHidden)
        }
        .frame(height: 30)
    }
}

struct LanguagesButtonView: View {
    @Binding var activeLang: Constants.Language
    @Binding var isHidden: Bool
    
    var body: some View {
        Button(action: {
            isHidden.toggle()
        }) {
            HStack {
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.teal)
                    .animation(.bouncy, value: isHidden)
                
                Text(activeLang.rawValue)
                    .tint(.teal)
                    .frame(width: isHidden ? 30 : 0, alignment: .leading)
                    .animation(nil, value: isHidden)
            }
        }
        .offset(x: isHidden ? 103 : 0)
        .zIndex(1)
    }
}

struct LanguagesPanelView: View {
    @ObservedObject var appearance = Appearance.shared
    @Binding var activeLang: Constants.Language
    @Binding var isHidden: Bool

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Constants.Language.allCases, id: \.rawValue) { lang in
                Button(action: {
                    activeLang = lang
                    Localization.shared.setLanguage(lang)
                    isHidden.toggle()
                }) {
                    Text(lang.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(lang == activeLang ? appearance.theme.textColor : appearance.theme.secondaryTextColor)
                        .frame(width: 48, height: 30, alignment: .center)
                        .background(lang == activeLang ? appearance.theme.secondaryBackgroundColor : Color.clear)
                }
                
                if Constants.Language.allCases.firstIndex(of: lang) != Constants.Language.allCases.count - 1 {
                    Divider()
                        .frame(width: 3, height: 25)
                        .background(Color.gray)
                        .opacity(0.5)
                }
            }
        }
        .background(appearance.theme.secondaryBackgroundColor)
        .cornerRadius(Constants.cornerRadius)
        .opacity(isHidden ? 0 : 1)
        .animation(isHidden ? .easeOut(duration: 0.2) : .easeIn(duration: 0.2), value: isHidden)
    }
}

#Preview {
    LanguageSwitcherView()
}
