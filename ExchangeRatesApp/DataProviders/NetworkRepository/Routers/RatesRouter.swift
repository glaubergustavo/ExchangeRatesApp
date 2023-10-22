//
//  RatesRouter.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 20/10/23.
//

import Foundation

enum RatesRouter {
    
    case fluctuation(baseCoin: String, symbols: [String], startDate: String, endDate: String)
    case timeseries(baseCoin: String, symbol: String, startDate: String, endDate: String)
    
    var path: String {
        switch self {
        case .fluctuation:
            return RatesApi.fluctuation
        case .timeseries:
            return RatesApi.timeseries
        }
    }
    
    func asUrlRequest() throws -> URLRequest? {
        guard var url = URL(string: RatesApi.baseUrl) else { return nil }
        
        switch self {
        case .fluctuation(let baseCoin, let symbols, let startDate, let endDate):
            url.append(queryItems: [
                URLQueryItem(name: "access_key", value: RatesApi.apiKey),
                URLQueryItem(name: "base", value: baseCoin),
                URLQueryItem(name: "symbols", value: symbols.joined(separator: ",")),
                URLQueryItem(name: "start_date", value: startDate),
                URLQueryItem(name: "end_date", value: endDate)
            ])
        case .timeseries(let baseCoin, let symbol, let startDate, let endDate):
            url.append(queryItems: [
                URLQueryItem(name: "access_key", value: RatesApi.apiKey),
                URLQueryItem(name: "base", value: baseCoin),
                URLQueryItem(name: "symbol", value: symbol),
                URLQueryItem(name: "start_date", value: startDate),
                URLQueryItem(name: "end_date", value: endDate)
            ])
        }
        
        var request = URLRequest(url: url.appendingPathComponent(path), timeoutInterval: Double.infinity)
        request.httpMethod = HttpMethod.get.rawValue
        request.addValue(RatesApi.apiKey, forHTTPHeaderField: "access_key")
        
        return request
    }
}
