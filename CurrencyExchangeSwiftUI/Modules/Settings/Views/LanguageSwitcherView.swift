//
//  LanguageSwitch.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 26.11.2024.
//

import SwiftUI
import Foundation

struct LanguageSwitcherView: View {
    @State var activeLang: Constants.Language = AppState.shared.language
    @State var isHidden: Bool = true
        
    var body: some View {
        Group {
            HStack(spacing: 0) {
                LanguagesButtonView(activeLang: $activeLang, isHidden: $isHidden)
                LanguagesPanelView(activeLang: $activeLang, isHidden: $isHidden)
            }
            .frame(height: 30) // Fixes animation choppiness
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct LanguagesButtonView: View {
    @EnvironmentObject var state: AppState
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
                    .foregroundStyle(.teal)
                    .frame(width: isHidden ? 30 : 0, alignment: .leading)
                    .animation(nil, value: isHidden)
            }
        }
        .offset(x: isHidden ? CGFloat(Constants.Language.allCases.count * 50) : 0)
        .zIndex(1)
    }
}

struct LanguagesPanelView: View {
    @EnvironmentObject var state: AppState
    @Binding var activeLang: Constants.Language
    @Binding var isHidden: Bool

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Constants.Language.allCases, id: \.rawValue) { lang in
                Button(action: {
                    activeLang = lang
                    state.setLanguage(lang)
                    isHidden.toggle()
                }) {
                    Text(lang.rawValue + " " + lang.flag)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(lang == activeLang ? state.theme.textColor : state.theme.secondaryTextColor)
                        .frame(width: 48, height: 30, alignment: .center)
                        .background(lang == activeLang ? state.theme.secondaryBackgroundColor : Color.clear)
                }
                
                if Constants.Language.allCases.firstIndex(of: lang) != Constants.Language.allCases.count - 1 {
                    Divider()
                        .frame(width: 2, height: 25)
                        .background(Color.gray)
                        .opacity(0.5)
                }
            }
        }
        .roundedCardStyle(state)
        .opacity(isHidden ? 0 : 1)
        .animation(isHidden ? .easeOut(duration: 0.2) : .easeIn(duration: 0.2), value: isHidden)
    }
}

#Preview {
    LanguageSwitcherView()
}

#Preview {
    Assembly.createDashboardView()
}
