//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Grekhem on 20.08.2022.
//

import Foundation
import XMLParsing

protocol INetworkService: AnyObject {
    func loadData(complition: @escaping (Result<CurrencyDTO, Error>) -> ())
}

final class NetworkService {}

extension NetworkService: INetworkService {
    func loadData(complition: @escaping (Result<CurrencyDTO, Error>) -> ()) {
        guard let url = URL(string: "https://www.cbr.ru/scripts/XML_daily.asp") else { assert(false)}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                complition(.failure(error))
            }
            guard let data = data else { return }
            do {
                let newData = try XMLDecoder().decode(CurrencyDTO.self, from: data)
                complition(.success(newData))
            }
            catch let error {
                complition(.failure(error))
            }
        }.resume()
    }
}
