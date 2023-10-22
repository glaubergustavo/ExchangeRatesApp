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
    
    var body: some View {
        NavigationView {
            VStack {
                if case .loading = viewModel.currentState {
                    ProgressView()
                        .scaleEffect(2.2, anchor: .center)
                } else if case .success = viewModel.currentState {
                    listCurrenciesView
                } else if case .failure = viewModel.currentState {
                    errorView
                }
            }
        }
        .onAppear {
            viewModel.doFetchCurrencySymbols()
        }
    }
    
    private var listCurrenciesView: some View {
        List(viewModel.searchResults, id: \.symbol, selection: $selection) { item in
            HStack {
                Text(item.symbol)
                    .font(.system(size: 14, weight: .bold))
                Text("-")
                    .font(.system(size: 14, weight: .semibold))
                Text(item.fullName)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .searchable(text: $searchText, prompt: "Buscar moeda base")
        .onChange(of: searchText) { searchText in
            if searchText.isEmpty {
                return viewModel.searchResults = viewModel.currencySymbols
            } else {
                return viewModel.searchResults = viewModel.currencySymbols.filter {
                    $0.symbol.contains(searchText.uppercased()) ||
                    $0.fullName.uppercased().contains(searchText.uppercased())
                }
            }
        }
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
    
    private var errorView: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .frame(width: 60, height: 44)
                .padding(.bottom, 4)
            
            Text("Ocorreu um erro na busca dos simbolos das moedas!")
                .font(.headline.bold())
                .multilineTextAlignment(.center)
            
            Button {
                viewModel.doFetchCurrencySymbols()
            } label: {
                Text("Tentar novamente?")
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .padding()
    }
}

struct BaseCurrencyFilterView_Previews: PreviewProvider {
    static var previews: some View {
        BaseCurrencyFilterView()
    }
}
