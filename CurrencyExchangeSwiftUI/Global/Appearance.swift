//
//  Themes.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 28.11.2024.
//

import SwiftUI

// MARK: - Styles
extension View {
    func subHeaderStyle(_ appearance: Appearance) -> some View {
        self
            .font(.body)
            .foregroundStyle(appearance.theme.secondaryTextColor)
    }
    
    func headerStyle(_ appearance: Appearance) -> some View {
        self
            .font(.title3)
            .foregroundStyle(appearance.theme.secondaryTextColor)
    }
    func bodyStyle(_ appearance: Appearance) -> some View {
        self
            .font(.body)
            .foregroundStyle(appearance.theme.textColor)
    }
    func headlineStyle(_ appearance: Appearance) -> some View {
        self
            .font(.headline)
            .foregroundStyle(appearance.theme.textColor)
    }
    func titleStyle(_ appearance: Appearance) -> some View {
        self
            .font(.title)
            .foregroundStyle(appearance.theme.textColor)
    }
}

class Appearance: ObservableObject {
    static var shared = Appearance()
    private init() {}

    @Published private(set) var theme: Theme = StorageManager.shared.loadAppTheme() ?? .light
    
    func setTheme(_ newTheme: Theme) {
        theme = newTheme
        StorageManager.shared.saveAppTheme(to: theme)
        print("Set theme: \(newTheme)")
    }
    
    func toggleTheme() {
        setTheme(theme == .dark ? .light : .dark)
    }
    
    // MARK: - Theme and Colors
    enum Theme: CaseIterable, Codable {
        case light
        case dark
                
        var backgroundColor: Color {
            switch self {
            case .light:
                return .white
            case .dark:
                return .black
            }
        }
        
        var secondaryBackgroundColor: Color {
            switch self {
            case .light:
                return .gray.opacity(0.15)
            case .dark:
                return .white.opacity(0.15)
            }
        }
        
        var textColor: Color {
            switch self {
            case .light:
                return .black
            case .dark:
                return .white
            }
        }
        
        var secondaryTextColor: Color {
            switch self {
            case .light:
                return .secondary
            case .dark:
                return .white.opacity(0.5)
            }
        }
        
        var accentColor: Color {
            switch self {
            case .light, .dark:
                return .red
            }
        }
        
        var chartColor: Color {
            switch self {
            case .light, .dark:
                return .blue.opacity(1)
            }
        }
        
        var actionableColor: Color {
            switch self {
            case .light:
                return .blue
            case .dark:
                return .blue
            }
        }
        
        var themeSwitcherColor: Color {
            switch self {
            case .light:
                return .yellow.opacity(0.8)
            case .dark:
                return .indigo.opacity(0.8)
            }
        }
    }
}

