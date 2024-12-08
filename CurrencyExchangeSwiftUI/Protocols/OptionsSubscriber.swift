//
//  OptionsSubscriber.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 08.12.2024.
//

import Combine

protocol OptionsSubscriber {
    func subscribeToOptionChanges(
        cancellables: inout Set<AnyCancellable>,
        onChange: @escaping (Constants.City, Bool, Constants.Options.Availability) -> Void
    )
}

extension OptionsSubscriber {
    func subscribeToOptionChanges(
        cancellables: inout Set<AnyCancellable>,
        onChange: @escaping (Constants.City, Bool, Constants.Options.Availability) -> Void
    ) {
        Publishers.CombineLatest3(
            AppState.shared.$selectedCity,
            AppState.shared.$includeOnline,
            AppState.shared.$workingAvailability
        )
        .dropFirst()
        .sink { onChange($0, $1, $2) }
        .store(in: &cancellables)
    }
}

