//
//  NavigationContainer.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 07.01.2025.
//

import SwiftUI

struct NavigationContainer<RootView: View>: View {
    @StateObject private var router = Router()
    let rootView: RootView
    
    init(rootView: RootView) {
        self.rootView = rootView
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            rootView
                .navigationBarBackButtonHidden(true)
                .environmentObject(router)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .organizations:
                        router.listView
                    }
                }
        }
    }
}
