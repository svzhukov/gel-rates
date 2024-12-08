//
//  BackButtonView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 08.12.2024.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(translated("Back"))
            }
        }
    }
}
