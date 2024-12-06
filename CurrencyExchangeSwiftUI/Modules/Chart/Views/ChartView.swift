//
//  ExchangeGraphView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 24.10.2024.
//

import Charts
import Foundation
import SwiftUI

@available(iOS 16.0, *)
struct ExtremePoint: Identifiable {
    let id = UUID()
    let item: ChartDisplayItem
    let color: Color
}

@available(iOS 16.0, *)
struct PointMarkAnimation: Identifiable {
    let id = UUID()
    var points: [ExtremePoint] = []
    var isVisible: Bool = false
}

@available(iOS 16.0, *)
struct ChartView: View {
    @ObservedObject var appearance = Appearance.shared
    var vm: ChartVM

    init(vm: ChartVM) {
        self.vm = vm
    }

    var body: some View {
        VStack {
            TitleView("Chart GEL to USD")
            ChartContentView(vm: self.vm)
            ChartButtonsView(vm: self.vm)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            self.vm.fetchData()
        }
    }
}

// MARK: - Chart Content
@available(iOS 16.0, *)
struct ChartContentView: View {
    @ObservedObject var vm: ChartVM
    @State private var pointAnimation: PointMarkAnimation = PointMarkAnimation()
    
    init(vm: ChartVM) {
        self.vm = vm
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(Appearance.shared.theme.secondaryBackgroundColor)
            .frame(height: 300)
            .overlay(
                Group {
                    if let items = vm.periodicChartItems {
                        chartContent(items: items)
                    } else {
                        BasicProgressView()
                    }
                }
            )
    }
    
    private func chartContent(items: [ChartDisplayItem]) -> some View {
        Chart {
            ForEach(items) { item in
                chartAreaContent(item)
                chartLineContent(item)
            }
            chartPointContent()
        }
        .foregroundStyle(linearGradient(items))
        .chartXAxis {
            ChartAxisContent.xAxis(for: vm.selectedTimeRange)
        }
        .chartYAxis {
            ChartAxisContent.yAxis()
        }
        .chartYScale(domain: items.minPrice!.price - 0.008...items.maxPrice!.price + 0.008)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .padding(.trailing, 10)
        
        .availabilityOnChange(of: vm.periodicChartItems) {
            if let items = vm.periodicChartItems {
                addDelayedPointMarks(items, delay: 0.3)
            }
        }
    }
    
    private func linearGradient(_ items: [ChartDisplayItem]) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Appearance.shared.theme.chartColor.opacity(0.9),
                Appearance.shared.theme.chartColor.opacity(0.1),
            ]),
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: gradientEndYPoint(items))
        )
    }
    
    private func addDelayedPointMarks(_ items: [ChartDisplayItem], delay: Double) {
        guard let max = items.maxPrice, let min = items.minPrice else { return }
        pointAnimation = PointMarkAnimation()
        let animationId = pointAnimation.id
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: 0.5)) {  // Explicit animation only for points
                if animationId == pointAnimation.id {
                    pointAnimation.points.append(contentsOf: [ExtremePoint(item: max, color: .green), ExtremePoint(item: min, color: .red)])
                    pointAnimation.isVisible = true
                }
            }
        }
    }
    
    private func gradientEndYPoint(_ items: [ChartDisplayItem]) -> Double {
        guard let min = items.minPrice?.price, let max = items.maxPrice?.price else { return 0 }
        let offset = 0.008
        return abs(min / max - 1) + offset
    }
    
    private func chartAreaContent(_ item: ChartDisplayItem) -> some ChartContent {
        AreaMark(
            x: .value("Date", item.date),
            y: .value("Price", item.price)
        )
        .opacity(0.5)
    }
    
    private func chartLineContent(_ item: ChartDisplayItem) -> some ChartContent {
        LineMark(
            x: .value("Date", item.date),
            y: .value("Price", item.price)
        )
        .lineStyle(StrokeStyle(lineWidth: 1.5))
        .foregroundStyle(Appearance.shared.theme.chartColor).opacity(0.65)
    }
    
    private func chartPointContent() -> some ChartContent {
        ForEach(pointAnimation.points) { point in
            PointMark(
                x: .value("Date", point.item.date),
                y: .value("Price", point.item.price)
            )
            .foregroundStyle(Appearance.shared.theme.accentColor)
            .opacity(pointAnimation.isVisible ? 1 : 0)
            .annotation(position: .automatic) {
                Text("\(point.item.price, specifier: "%.3f")")
                    .font(.system(size: 10))
                    .foregroundColor(Appearance.shared.theme.secondaryTextColor)
            }
        }
    }
}


// MARK: - Chart Axis
@available(iOS 16.0, *)
struct ChartAxisContent {
    static func yAxis() -> AnyAxisContent {
        return AnyAxisContent (
            AxisMarks {
                AxisValueLabel()
                    .foregroundStyle(Appearance.shared.theme.secondaryTextColor)
                AxisTick()
                    .foregroundStyle(Appearance.shared.theme.secondaryBackgroundColor)
            })
    }
    
    static func xAxis(for timeRange: TimeRange?) -> AnyAxisContent {
        switch timeRange {
        case .month:
            return AnyAxisContent(monthlyAxis())
        case .week:
            return AnyAxisContent(weeklyAxis())
        case .halfYear, .year, .none:
            return AnyAxisContent(yearlyAxis())
        }
    }

    private static func monthlyAxis() -> some AxisContent {
        AxisMarks(values: .stride(by: .day, count: 7)) {
            AxisValueLabel(format: .dateTime.day(.twoDigits).month(.twoDigits))
                .offset(y: -15)
                .foregroundStyle(Appearance.shared.theme.secondaryTextColor)
                .font(.system(size: 8))
            AxisGridLine()
                .foregroundStyle(Appearance.shared.theme.secondaryBackgroundColor)
        }
    }

    private static func weeklyAxis() -> some AxisContent {
        AxisMarks(values: .stride(by: .day, count: 1)) {
            AxisValueLabel(format: .dateTime.day(.twoDigits).month(.twoDigits))
                .offset(y: -15)
                .foregroundStyle(Appearance.shared.theme.secondaryTextColor)
                .font(.system(size: 8))
            AxisGridLine()
                .foregroundStyle(Appearance.shared.theme.secondaryBackgroundColor)
        }
    }

    private static func yearlyAxis() -> some AxisContent {
        AxisMarks(values: .stride(by: .month, count: 1)) { value in
            if let date = value.as(Date.self),
               Calendar.current.component(.month, from: date) == 1 {
                AxisValueLabel(format: .dateTime.year())
                    .foregroundStyle(Appearance.shared.theme.secondaryTextColor)
                    .font(.system(size: 8))
            } else if value.index % 2 == 0 {
                AxisValueLabel(format: .dateTime.month())
                    .offset(y: -15)
                    .foregroundStyle(Appearance.shared.theme.secondaryTextColor)
                    .font(.system(size: 8))

            }
            AxisGridLine()
                .foregroundStyle(Appearance.shared.theme.secondaryBackgroundColor)
        }
    }
}

#Preview("Dashboard") {
    Assembly.createDashboardView()
}

