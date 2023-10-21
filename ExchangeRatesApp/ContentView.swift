//
//  ContentView.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 20/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                doFetchData()
            } label: {
                Image(systemName: "network")
            }
        }
        .padding()
    }
    
    private func doFetchData() {
        let rateFluctuationDataProvider = RatesFluctuationDataProvider()
        rateFluctuationDataProvider.delegate = self
        rateFluctuationDataProvider.fetchFluctuation(by: "BRL", from: ["USD", "EUR"], startDate: "2022-10-11", endDate: "2022-11-11")
        
        let currencySymbolsDataProvider = CurrencySymbolsDataProvider()
        currencySymbolsDataProvider.delegate = self
        currencySymbolsDataProvider.fetchSymbols()
        
        let rateHistoricalDataProvider = RatesHistoricalDataProvider()
        rateHistoricalDataProvider.delegate = self
        rateHistoricalDataProvider.fetchTimeseries(by: "BRL", from: ["USD", "EUR"], startDate: "2022-10-11", endDate: "2022-11-11")
    }
}

extension ContentView: RatesFluctuationDataProviderDelegate {
    func success(model: RatesFluctuationObject) {
        print("RatesFluctuationModel: \(model)\n\n")
    }
}

extension ContentView: CurrencySymbolsDataProviderDelegate {
    func success(model: CurrencySymbolObject) {
        print("CurrencySymbolModel: \(model)\n\n")
    }
}

extension ContentView: RatesHistoricalDataProviderDelegate {
    func success(model: RatesHistoricalObject) {
        print("RatesHistoricalModel: \(model)\n\n")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
