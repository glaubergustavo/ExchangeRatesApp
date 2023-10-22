//
//  RatesFluctuationViewModel.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 22/10/23.
//

import Foundation
import SwiftUI
import Combine

extension RatesFluctuationView {
    @MainActor class ViewModel: ObservableObject {
        
        enum ViewState {
            case start
            case loading
            case success
            case failure
        }
        
        @Published var ratesFluctuation = [RateFluctuationModel]()
        @Published var searchResults = [RateFluctuationModel]()
        @Published var timeRange = TimeRangeEnum.today
        @Published var baseCurrency = "BRL"
        @Published var currencies = [String]()
        @Published var currentState: ViewState = .start

        private let dataProvider: RatesFluctuationDataProvider?
        private var cancelables = Set<AnyCancellable>()
        
        init(dataProvider: RatesFluctuationDataProvider = RatesFluctuationDataProvider()) {
            self.dataProvider = dataProvider
        }
        
        func doFetchRatesFluctuation(timeRange: TimeRangeEnum) {
            currentState = .loading
            withAnimation {
                self.timeRange = timeRange
            }
            
            let stardDate = timeRange.date
            let endDate = Date()
            dataProvider?.fetchFluctuation(by: baseCurrency, from: currencies, startDate: stardDate.formatter(to: "yyyt-MM-dd"), endDate: endDate.formatter(to: "yyyt-MM-dd"))
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.currentState = .success
                    case .failure(_):
                        self.currentState = .failure
                    }
                }, receiveValue: { ratesFluctuation in
                    withAnimation {
                        self.ratesFluctuation = ratesFluctuation.sorted { $0.symbol < $1.symbol}
                        self.searchResults = self.ratesFluctuation
                    }
                }).store(in: &cancelables)
        }
        
        nonisolated func success(model: [RateFluctuationModel]) {
            DispatchQueue.main.async {
                
            }
        }
    }
}
