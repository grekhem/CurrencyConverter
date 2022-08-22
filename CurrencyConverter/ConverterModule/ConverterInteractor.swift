//
//  ConverterIteractor.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation

protocol IConverterInteractor: AnyObject {
    var dataLoaded: (([CurrencyEntity]) -> Void)? { get set }
}

final class ConverterInteractor {
    private weak var networkService: INetworkService?
    private var arrayOfCurrency: [CurrencyEntity] = []
    var dataLoaded: (([CurrencyEntity]) -> Void)?
    
    init(network: INetworkService){
        self.networkService = network
        self.fetchData()
    }
    
    func fetchData() {
        self.networkService?.loadData { (result: Result<CurrencyDTO, Error>) in
            switch result {
            case .success(let data):
                var count = 0
                for item in data.valute {
                    let valute = CurrencyEntity(id: item.id, numCode: item.numCode, charCode: item.charCode, nominal: Int(item.nominal) ?? 1, name: item.name, value: Double(item.value.replacingOccurrences(of: ",", with: ".")) ?? 0)
                    self.arrayOfCurrency.append(valute)
                    count = count + 1
                    if count == data.valute.count {
                        self.dataLoaded?(self.arrayOfCurrency)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ConverterInteractor: IConverterInteractor {
    
}
