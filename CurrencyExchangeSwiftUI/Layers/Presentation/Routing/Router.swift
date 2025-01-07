//
//  Router.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 07.01.2025.
//

import SwiftUI

enum Route: Hashable {
    case organizations
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    lazy var listView: some View = {
        Assembly.createListView()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
    }()
    
    func navigate(to route: Route) {
        path.append(route)
    }
}
