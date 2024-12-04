//
//  TitleView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 04.12.2024.
//

import SwiftUI

struct TitleView: View {
    @ObservedObject var appearance = Appearance.shared
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(translated(title))
            .headerStyle(appearance)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 30)
            .padding(.bottom, -5)
    }
}

#Preview {
    TitleView("Title")
}
