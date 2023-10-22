//
//  RatesHistoricalDataProvider.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 21/10/23.
//

import Foundation

protocol RatesHistoricalDataProviderDelegate: DataProviderManagerDelegate {
    func success(model: [RateHistoricalModel])
}

class RatesHistoricalDataProvider: DataProviderManager<RatesHistoricalDataProviderDelegate, [RateHistoricalModel]> {
    
    private let ratesStore: RatesStore
    
    init(ratesSotre: RatesStore = RatesStore()) {
        self.ratesStore = ratesSotre
    }
    
    func fetchTimeseries(by base: String, from symbol: String, startDate: String, endDate: String) {
        Task.init {
            do {
                let object = try await ratesStore.fetchTimeseries(by: base, from: symbol, startDate: startDate, endDate: endDate)
                delegate?.success(model: object.flatMap({ (period, rates) -> [RateHistoricalModel] in
                    return rates.map { RateHistoricalModel(symbol: $0, period: period.toDate(), endRate: $1)}
                }))
            } catch {
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}
