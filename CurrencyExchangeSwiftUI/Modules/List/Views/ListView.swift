//
//  ExchangeList.swift
//  CurrencyExchangeSwiftUI
//
//  Created by Sasha Zhukov on 24.11.2024.
//

import Foundation
import SwiftUI

struct ListView: View {
    @ObservedObject var vm: ListVM
    
    init(vm: ListVM) {
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            if let items = self.vm.listItems {
                    ForEach(items) { (item: ListDisplayItem) in
                        Group {
                            VStack {
                                listHeaderView(item: item)
                                listContentView(item: item)
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    }
            } else {
                ProgressView("Loading...")
            }
        }

        .onAppear {
            vm.fetchData()
        }
    }
}

struct listHeaderView: View {
    let item: ListDisplayItem
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 38, height: 38)
                .foregroundStyle(Color(.white))
                .shadow(color: .white, radius: 2)
                .overlay(
                    Image(item.bank.icon.name)
                    .if(item.bank.icon.fileExtension == "png") { view in
                        view
                            .resizable()
                            .frame(maxWidth: 32, maxHeight: 32)
                    }
                        .frame(maxWidth: 32, maxHeight: 32)
                        .scaledToFit()
                )


            Text(item.bank.name.en!)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
}

struct listContentView: View {
    let item: ListDisplayItem
    
    var body: some View {
        HStack {
            Text(NSLocalizedString("list_header_buy", comment: "buy"))
                .foregroundColor(.gray)
            Spacer()
            Text(NSLocalizedString("list_header_sell", comment: "sell"))
                .foregroundColor(.gray)
        }
        
        ForEach(item.bank.currencies) { (currency: Currency) in
            HStack {
                Text("\(currency.buy, specifier: "%.3f") ₾")
                    .font(.title3)
                    .frame(maxWidth: 100, alignment: .leading)
                Spacer()
                Text("\(currency.type.flag)  1 \(currency.type.symbol)")
                    .font(.title3).bold()
                    .frame(alignment: .leading)
                Spacer()
                Text("\(currency.sell, specifier: "%.3f") ₾")
                    .font(.title3)
                    .frame(maxWidth: 100, alignment: .trailing)
            }
            .padding(.vertical, -4)
        }
    }
}


#Preview {
    AppAssembly.createListView()
}
