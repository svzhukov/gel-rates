//
//  ExchangeGraphView.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha on 24.10.2024.
//

import Charts
import Foundation
import SwiftUI

struct ChartView: View {
    @ObservedObject var appearance = Appearance.shared

    var vm: ChartVM

    init(vm: ChartVM) {
        self.vm = vm
    }

    var body: some View {
        VStack {
            ChartTitleView()
            ChartContentView(vm: self.vm)
            ChartButtonsView(vm: self.vm)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            self.vm.fetchData()
        }
    }
}

// MARK: - Chart Title
struct ChartTitleView: View {
    @ObservedObject var appearance = Appearance.shared

    var body: some View {
        Text(translated("GEL / USD"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(appearance.theme.secondaryTextColor)
            .padding(.leading, 30)
            .padding(.bottom, -5)
    }
}

// MARK: - Chart Content
struct ChartContentView: View {
    @ObservedObject var appearance = Appearance.shared
    @ObservedObject var vm: ChartVM
    @State private var pointAnimation: PointMarkAnimation = PointMarkAnimation()
    
    init(vm: ChartVM) {
        self.vm = vm
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(appearance.theme.secondaryBackgroundColor)
            .frame(height: 300)
            .overlay(
                Group {
                    if let items = vm.periodicChartItems {
                        chartContent(items: items)
                    } else {
                        ProgressView(translated("Loading..."))
                    }
                }
            )
    }
    
    private func chartContent(items: [ChartDisplayItem]) -> some View {
        Chart {
            ForEach(items) { item in
                ChartAreaContent(item)
                ChartLineContent(item)
            }
            ChartPointContent(pointAnimation: pointAnimation)
        }
        .foregroundStyle(linearGradient(items))
        .chartXAxisConfiguration(for: vm.selectedTimeRange)
        .customAxisStyle(textColor: appearance.theme.secondaryTextColor)

        .chartYScale(domain: items.minPrice!.price - 0.008...items.maxPrice!.price + 0.008)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.trailing, 10)
//        .onChange(of: vm.selectedTimeRange, initial: true) {
//            addDelayedPointMarks(items, delay: 0.3)
//        }
    }
    
    private func linearGradient(_ items: [ChartDisplayItem]) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                appearance.theme.chartColor.opacity(0.9),
                appearance.theme.chartColor.opacity(0.1),
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
}

struct ChartAreaContent: ChartContent {
    let item: ChartDisplayItem
    init(_ item: ChartDisplayItem) {
        self.item = item
    }
    
    var body: some ChartContent {
        AreaMark(
            x: .value("Date", item.date),
            y: .value("Price", item.price)
        )
        .opacity(0.5)
    }
}

struct ChartLineContent: ChartContent {
    @ObservedObject var appearance = Appearance.shared

    let item: ChartDisplayItem
    init(_ item: ChartDisplayItem) {
        self.item = item
    }
    
    var body: some ChartContent {
        LineMark(
            x: .value("Date", item.date),
            y: .value("Price", item.price)
        )
        .lineStyle(StrokeStyle(lineWidth: 1.5))
        .foregroundStyle(appearance.theme.chartColor).opacity(0.65)
    }
}

struct ChartPointContent: ChartContent {
    @ObservedObject var appearance = Appearance.shared

    let pointAnimation: PointMarkAnimation
    
    var body: some ChartContent {
        ForEach(pointAnimation.points) { point in
            PointMark(
                x: .value("Date", point.item.date),
                y: .value("Price", point.item.price)
            )
            .foregroundStyle(appearance.theme.accentColor)
            .opacity(pointAnimation.isVisible ? 1 : 0)
            .annotation(position: .automatic) {
                Text("\(point.item.price, specifier: "%.3f")")
                    .font(.system(size: 10))
                    .foregroundColor(appearance.theme.secondaryTextColor)
            }
        }
    }
}

struct ExtremePoint: Identifiable {
    let id = UUID()
    let item: ChartDisplayItem
    let color: Color
}

struct PointMarkAnimation: Identifiable {
    let id = UUID()
    var points: [ExtremePoint] = []
    var isVisible: Bool = false
}

// MARK: - Chart Axis
struct ChartAxisModifier: ViewModifier {
    @ObservedObject var appearance = Appearance.shared
    let timeRange: TimeRange?
    
    func body(content: Content) -> some View {
        content.chartXAxis {
            switch timeRange {
            case .month:
                monthlyAxis
            case .week:
                weeklyAxis
            case .halfYear, .year, .none:
                yearlyAxis
            }
        }
    }
    
    private var monthlyAxis: some AxisContent {
        AxisMarks(values: .stride(by: .day, count: 7)) {
            AxisValueLabel(format: .dateTime.day(.twoDigits).month(.twoDigits))
                .offset(y: -15)
                .foregroundStyle(appearance.theme.secondaryTextColor)
            AxisGridLine()
        }
    }
    
    private var weeklyAxis: some AxisContent {
        AxisMarks(values: .stride(by: .day, count: 1)) {
            AxisValueLabel(format: .dateTime.day(.twoDigits).month(.twoDigits))
                .offset(y: -15)
                .foregroundStyle(appearance.theme.secondaryTextColor)
            AxisGridLine()
        }
    }
    
    private var yearlyAxis: some AxisContent {
        AxisMarks(values: .stride(by: .month, count: 1)) { value in
            if let date = value.as(Date.self),
               Calendar.current.component(.month, from: date) == 1 {
                AxisValueLabel(format: .dateTime.year())
                    .foregroundStyle(appearance.theme.secondaryTextColor)
            } else if value.index % 2 == 0 {
                AxisValueLabel(format: .dateTime.month())
                    .offset(y: -15)
                    .foregroundStyle(appearance.theme.secondaryTextColor)
            }
            AxisGridLine()
        }
    }
}

struct CustomAxisStyle: ViewModifier {
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel()
                        .foregroundStyle(textColor)
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisValueLabel()
                        .foregroundStyle(textColor)
                }
            }
    }
}

#Preview {
    Assembly.createDashboardView()
}
