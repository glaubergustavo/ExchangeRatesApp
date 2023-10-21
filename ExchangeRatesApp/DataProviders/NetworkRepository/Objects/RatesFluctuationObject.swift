//
//  RatesFluctuationObject.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 20/10/23.
//

import Foundation

typealias RatesFluctuationObject = [String: FluctuationObject]

struct FluctuationObject: Codable {
    let endRate: Double
    let change: Double
    let changePct: Double

    enum CodingKeys: String, CodingKey {
        case endRate = "end_rate"
        case change
        case changePct = "change_pct"
    }
}
