//
//  CurrencySymbolsDataProvider.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 21/10/23.
//

import Foundation
import Combine

protocol CurrencySymbolsDataProviderProtocol {
    func fetchSymbols() -> AnyPublisher<[CurrencySymbolModel], Error>
}

class CurrencySymbolsDataProvider: CurrencySymbolsDataProviderProtocol {
    
    private let currencyStore: CurrencyStore
    
    init(currencyStore: CurrencyStore = CurrencyStore()) {
        self.currencyStore = currencyStore
    }
    
    func fetchSymbols() -> AnyPublisher<[CurrencySymbolModel], Error> {
        return Future { promise in
            self.currencyStore.fetchSymbols { result, error in
                DispatchQueue.main.async {
                    if let error {
                        return promise(.failure(error))
                    }
                    
                    guard let symbols = result?.symbols else {
                        return
                    }
                    
                    let currenciesSymbol = symbols.map({ (key, value) -> CurrencySymbolModel in
                        return CurrencySymbolModel(symbol: key, fullName: value)
                    })
                    
                    return promise(.success(currenciesSymbol))
                }
            }
        }.eraseToAnyPublisher()
    }
}
