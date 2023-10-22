//
//  CurrencySymbolModel.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 22/10/23.
//

import Foundation

struct CurrencySymbolModel: Identifiable, Equatable {
    let id = UUID()
    var symbol: String
    var fullName: String
}
