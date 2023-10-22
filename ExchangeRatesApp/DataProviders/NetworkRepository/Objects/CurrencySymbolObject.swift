//
//  CurrencySymbolObject.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 21/10/23.
//

import Foundation

struct CurrencySymbolObject: Codable {
    var base: String?
    var success: Bool = false
    var symbols: SymbolObject?
}

typealias SymbolObject = [String : String]
