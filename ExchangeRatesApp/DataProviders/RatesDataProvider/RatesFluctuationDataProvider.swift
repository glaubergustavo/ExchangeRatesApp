//
//  RatesFluctuationDataProvider.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 21/10/23.
//

import Foundation

protocol RatesFluctuationDataProviderDelegate: DataProviderManagerDelegate {
    func success(model: [RateFluctuationModel])
}

class RatesFluctuationDataProvider: DataProviderManager<RatesFluctuationDataProviderDelegate, [RateFluctuationModel]> {
    
    private let ratesStore: RatesStore
    
    init(ratesSotre: RatesStore = RatesStore()) {
        self.ratesStore = ratesSotre
    }
    
    func fetchFluctuation(by base: String, from symbols: [String], startDate: String, endDate: String) {
        Task.init {
            do {
                let object = try await ratesStore.fetchFluctuation(by: base, from: symbols, startDate: startDate, endDate: endDate)
                delegate?.success(model: object.map({ (symbol, fluctuation) -> RateFluctuationModel in
                    return RateFluctuationModel(symbol: symbol, change: fluctuation.change, changePct: fluctuation.changePct, endRate: fluctuation.endRate)
                }))
            } catch {
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}
