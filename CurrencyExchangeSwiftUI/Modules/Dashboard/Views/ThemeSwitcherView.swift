//
//  ThemeSwitcher.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 28.11.2024.
//

import Foundation
import SwiftUI

struct ThemeSwitcherView: View {
    @State var img: String = imgString()
    
    var body: some View {
        Button {
            withAnimation {
                Appearance.shared.toggleTheme()
                img = ThemeSwitcherView.imgString()
            }
        } label: {
            Image(systemName: img)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(.teal)
        }
    }
    
    private static func imgString() -> String {
        return Appearance.shared.theme == .light ? "sun.max.fill" : "moon.circle.fill"
    }
}

#Preview {
    ThemeSwitcherView()
}
