//
//  BaseCurrencyFilterView.swift
//  ExchangeRatesApp
//
//  Created by madeinweb on 21/10/23.
//

import SwiftUI

protocol BaseCurrencyFilterViewDelegate {
    func didSelected(_ baseCurrency: String)
}

struct BaseCurrencyFilterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = ViewModel()
    
    @State private var searchText = ""
    @State private var selection: String?
    
    var delegate: BaseCurrencyFilterViewDelegate?
    
    var searchResults: [CurrencySymbolModel] {
        if searchText.isEmpty {
            return viewModel.currencySymbols
        } else {
            return viewModel.currencySymbols.filter {
                $0.symbol.contains(searchText.uppercased()) ||
                $0.fullName.uppercased().contains(searchText.uppercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            listCurrenciesView
        }
        .onAppear {
            viewModel.doFetchCurrencySymbols()
        }
    }
    
    private var listCurrenciesView: some View {
        List(searchResults, id: \.symbol, selection: $selection) { item in
            HStack {
                Text(item.symbol)
                    .font(.system(size: 14, weight: .bold))
                Text("-")
                    .font(.system(size: 14, weight: .semibold))
                Text(item.fullName)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Filtrar moedas")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                if let selection {
                    delegate?.didSelected(selection)
                }
                dismiss()
            } label: {
                Text("OK")
                    .fontWeight(.bold)
            }
        }
    }
}

struct BaseCurrencyFilterView_Previews: PreviewProvider {
    static var previews: some View {
        BaseCurrencyFilterView()
    }
}
