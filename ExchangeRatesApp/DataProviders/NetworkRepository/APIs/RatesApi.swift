//
//  RatesApi.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 20/10/23.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

struct RatesApi {
    
    static let baseUrl = "http://api.exchangeratesapi.io/v1/"
    static let apiKey = "bb96e9f2939c41c0348bb186cb087fa2"
    static let fluctuation = "fluctuation"
    static let symbols = "symbols"
    static let timeseries = "timeseries"
}
