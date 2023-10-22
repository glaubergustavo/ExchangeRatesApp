//
//  RateHistoricalModel.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 22/10/23.
//

import Foundation

struct RateHistoricalModel: Identifiable, Equatable {
    let id = UUID()
    var symbol: String
    var period: Date
    var endRate: Double
}
