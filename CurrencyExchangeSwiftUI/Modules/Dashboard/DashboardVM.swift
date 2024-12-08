//
//  DashboardVM.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 29.11.2024.
//

import Foundation
import Combine

class DashboardVM: ObservableObject {
    @Published var title: String = "Best exchange rates"
    let chartVM: ChartVM
    let listVM: ListVM
    let bestRatesVM: BestRatesVM
    let conversionVM: ConversionVM
    
    private var cancellables = Set<AnyCancellable>()
    
    init(chartVM: ChartVM, listVM: ListVM, bestRatesVM: BestRatesVM, conversionVM: ConversionVM) {
        self.chartVM = chartVM
        self.listVM = listVM
        self.bestRatesVM = bestRatesVM
        self.conversionVM = conversionVM
    }
    
    func updateTitle() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: AppState.shared.language.rawValue)
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)

        title = translated("Best exchange rates") + translated(" in ") + "\(translated(AppState.shared.selectedCity.rawValue))" + translated(" on ") + "\(formattedDate)"
    }
}




