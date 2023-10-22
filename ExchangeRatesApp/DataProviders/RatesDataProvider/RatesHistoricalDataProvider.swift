//
//  RatesHistoricalDataProvider.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 21/10/23.
//

import Foundation
import Combine

protocol RatesHistoricalDataProviderProtocol {
    func fetchTimeseries(by base: String, from symbol: String, startDate: String, endDate: String) -> AnyPublisher<[RateHistoricalModel], Error>
}

class RatesHistoricalDataProvider: RatesHistoricalDataProviderProtocol {
    
    private let ratesStore: RatesStore
    
    init(ratesSotre: RatesStore = RatesStore()) {
        self.ratesStore = ratesSotre
    }
    
    func fetchTimeseries(by base: String, from symbol: String, startDate: String, endDate: String) -> AnyPublisher<[RateHistoricalModel], Error> {
        return Future { promise in
            self.ratesStore.fetchTimeseries(by: base, from: symbol, startDate: startDate, endDate: endDate) { result, error in
                DispatchQueue.main.async {
                    if let error {
                        return promise(.failure(error))
                    }
                    
                    guard let rates = result?.rates else {
                        return //promise(.failure(error))
                    }
                    
                    let rateHistorical = rates.flatMap({ (key, rates) -> [RateHistoricalModel] in
                        return rates.map { RateHistoricalModel(symbol: symbol, period: key.toDate(), endRate: $1) }
                    })
                    
                    return promise(.success(rateHistorical))
                }
            }
        }.eraseToAnyPublisher()
    }
}
