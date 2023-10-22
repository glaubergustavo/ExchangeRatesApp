//
//  RateFluctuationDetailViewModel.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 22/10/23.
//

import Foundation
import SwiftUI
import Combine

extension RateFluctuationDetailView {
    @MainActor class ViewModel: ObservableObject {
        
        enum ViewState {
            case start
            case loading
            case success
        }
        
        @Published var ratesFluctuation = [RateFluctuationModel]()
        @Published var ratesHistorical = [RateHistoricalModel]()
        @Published var timeRange = TimeRangeEnum.today
        
        @Published var baseCurrency: String?
        @Published var fromCurrency: String?
        @Published var rateFluctuation: RateFluctuationModel?
        @Published var currentState: ViewState = .start
        
        private var cancelables = Set<AnyCancellable>()
        private var fluctuationDataProvider: RatesFluctuationDataProvider?
        private var historicalDataProvider: RatesHistoricalDataProvider?
        
        
        var titile: String {
            return "\(baseCurrency ?? "") a \(fromCurrency)"
        }
        
        var symbol: String {
            return rateFluctuation?.symbol ?? ""
        }
        
        var endRate: Double {
            return rateFluctuation?.endRate ?? 0.0
        }
        
        var changePct: Double {
            return rateFluctuation?.changePct ?? 0.0
        }
        
        var change: Double {
            return rateFluctuation?.change ?? 0.0
        }
        
        var changeDescription: String {
            switch timeRange {
            case .today:
                return "\(change.formatter(decimalPlaces: 4, with: true))"
            case .thisWeek:
                return "\(change.formatter(decimalPlaces: 4, with: true))"
            case .thisMonth:
                return "\(change.formatter(decimalPlaces: 4, with: true))"
            case .thisSemester:
                return "\(change.formatter(decimalPlaces: 4, with: true))"
            case .thisYear:
                return "\(change.formatter(decimalPlaces: 4, with: true))"
            }
        }
        
        var hasRates: Bool {
            return ratesHistorical.filter { $0.endRate > 0 }.count > 0
        }
        
        var xAxisStride: Calendar.Component {
            switch timeRange {
            case .today:
                return .hour
            case .thisWeek, .thisMonth:
                return .day
            case .thisSemester, .thisYear:
                return .month
            }
        }
        
        var xAxisStrideCount: Int {
            switch timeRange {
            case .today:
                return 6
            case .thisWeek:
                return 2
            case .thisMonth:
                return 6
            case .thisSemester:
                return 2
            case .thisYear:
                return 3
            }
        }
        
        var yAxisMin: Double {
            let min = ratesHistorical.map { $0.endRate }.min() ?? 0.0
            return (min - (min * 0.02))
        }
        
        var yAxisMax: Double {
            let max = ratesHistorical.map { $0.endRate }.max() ?? 0.0
            return (max - (max * 0.02))
        }
        
        func xAxisLabelFormatStyle(for date: Date) -> String {
            switch timeRange {
            case .today:
                return date.formatter(to: "HH:mm")
            case .thisWeek, .thisMonth:
                return date.formatter(to: "dd, MMM")
            case .thisSemester:
                return date.formatter(to: "MMM")
            case .thisYear:
                return date.formatter(to: "MMM, YYYY")
            }
        }
        
        init(fluctuationDataProvider: RatesFluctuationDataProvider = RatesFluctuationDataProvider(), historicalDataProvider: RatesHistoricalDataProvider = RatesHistoricalDataProvider()) {
            self.fluctuationDataProvider = fluctuationDataProvider
            self.historicalDataProvider = historicalDataProvider
        }
        
        func startStateView(baseCurrency: String, fromCurrency: String, timeRange: TimeRangeEnum) {
            self.baseCurrency = baseCurrency
            self.fromCurrency = fromCurrency
            doFetchData(from: timeRange)
        }
        
        func doFetchData(from timeRange: TimeRangeEnum) {
            currentState = .loading
            
            ratesFluctuation.removeAll()
            ratesHistorical.removeAll()
            
            withAnimation {
                self.timeRange = timeRange
            }
            
            doFetchRatesFluctuation()
            doFetchRatesHistorical()
        }
        
        func doComparation(with rateFluctuation: RateFluctuationModel) {
            self.fromCurrency = rateFluctuation.symbol
            self.rateFluctuation = rateFluctuation
            doFetchRatesHistorical()
        }
        
        func doFilter(by currency: String) {
            if let rateFluctuation = ratesFluctuation.filter({ $0.symbol == currency }).first {
                self.fromCurrency = rateFluctuation.symbol
                self.rateFluctuation = rateFluctuation
                doFetchRatesHistorical()
            }
        }
        
        private func doFetchRatesFluctuation() {
            if let baseCurrency {
                let startDate = timeRange.date
                let enDate = Date()
                fluctuationDataProvider?.fetchFluctuation(by: baseCurrency, from: [], startDate: startDate.formatter(to: "yyyy-MM-dd"), endDate: enDate.formatter(to: "yyyy-MM-dd"))
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            self.currentState = .success
                        case .failure(_):
                            print("Falhou")
                        }
                    }, receiveValue: { rateFluctuation in
                        self.rateFluctuation = rateFluctuation.filter({ $0.symbol == self.fromCurrency }).first
                        self.ratesFluctuation = rateFluctuation.filter({ $0.symbol != self.baseCurrency && $0.symbol != self.fromCurrency }).sorted { $0.symbol < $1.symbol }
                    }).store(in: &cancelables)
            }
        }
        
        private func doFetchRatesHistorical() {
            if let baseCurrency, let currency = fromCurrency {
                let startDate = timeRange.date.formatter(to: "yyyy-MM-dd")
                let endDate = Date().formatter(to: "yyyy-MM-dd")
                historicalDataProvider?.fetchTimeseries(by: baseCurrency, from: currency, startDate: startDate, endDate: endDate)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            self.currentState = .success
                        case .failure(_):
                            print("Falhou")
                        }
                    }, receiveValue: { ratesHistorical in
                        self.ratesHistorical = ratesHistorical.sorted { $0.period < $1.period }
                    }).store(in: &cancelables)
            }
        }
    }
}
