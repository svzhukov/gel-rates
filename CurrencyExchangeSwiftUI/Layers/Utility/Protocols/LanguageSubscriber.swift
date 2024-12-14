//
//  LanguageSubscriber.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 10.12.2024.
//

import Combine

protocol LanguageSubscriber {
    func subscribeToLanguageChanges(
        cancellables: inout Set<AnyCancellable>,
        onChange: @escaping (Constants.Language) -> Void
    )
}

extension LanguageSubscriber {
    func subscribeToLanguageChanges(
        cancellables: inout Set<AnyCancellable>,
        onChange: @escaping (Constants.Language) -> Void
    ) {
        AppState.shared.$language
            .sink { language in
                onChange(language)
            }
            .store(in: &cancellables)
    }
}

