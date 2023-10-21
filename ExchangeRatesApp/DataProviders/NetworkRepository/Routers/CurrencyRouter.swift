//
//  CurrencyRouter.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 20/10/23.
//

import Foundation

enum CurrencyRouter {
    
    case symbols
    
    var path: String {
        switch self {
        case .symbols:
            return RatesApi.symbols
        }
    }
    
    
    func asUrlRequest() throws -> URLRequest? {
        guard var url = URL(string: RatesApi.baseUrl) else { return nil }
        
        switch self {
        case .symbols:
            url.append(queryItems: [
                URLQueryItem(name: "access_key", value: RatesApi.apiKey)
            ])
            var request = URLRequest(url: url.appendingPathComponent(path), timeoutInterval: Double.infinity)
            request.httpMethod = HttpMethod.get.rawValue
            request.addValue(RatesApi.apiKey, forHTTPHeaderField: "access_key")
            
            return request
        }
    }
}
