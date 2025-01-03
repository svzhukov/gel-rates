//
//  DashboardViewModel.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 05.11.2024.
//

import Foundation

class ChartVM: ObservableObject {
    var service: HistoricalExchangeRateServiceProtocol
    
    var chartItems: [ChartDisplayItem]?
    @Published var periodicChartItems: [ChartDisplayItem]?

    var selectedTimeRange: TimeRange? {
        didSet {
            updatePeriodicGraphItems()
        }
    }

    private func updatePeriodicGraphItems() {
        guard let timeRange = selectedTimeRange else {
            periodicChartItems = nil
            return
        }
        periodicChartItems = chartItems?.filter { timeRange.dateRange.contains($0.date) }
    }

    init(service: HistoricalExchangeRateServiceProtocol) {
        self.service = service
    }
    
    func fetchData() {
        self.service.fetchHistoricalRates { [weak self] result in
            switch result {
            case .success(let model):
                self?.chartItems = ChartDisplayItem.mapModel(model)
                self?.selectedTimeRange = .year
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}

enum TimeRange: String, Equatable {
    case week, month, halfYear, year
}

extension TimeRange: CaseIterable, Identifiable {
    var localizedName: String {
        switch self {
        case .week: return translated("chart_button_week", comment: "")
        case .month: return translated("chart_button_month", comment: "месяц")
        case .halfYear: return translated("chart_button_six_months", comment: "")
        case .year: return translated("chart_button_year", comment: "")
        }
    }
    
    var id: String { self.rawValue }
}

extension TimeRange {
    var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .week:
            let week = calendar.date(byAdding: .weekOfYear, value: -1, to: now)!
            return week...now
        case .month:
            let month = calendar.date(byAdding: .month, value: -1, to: now)!
            return month...now
        case .halfYear:
            let halfYear = calendar.date(byAdding: .month, value: -6, to: now)!
            return halfYear...now
        case .year:
            let year = calendar.date(byAdding: .year, value: -1, to: now)!
            return year...now
        }
    }
}


