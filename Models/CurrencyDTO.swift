//
//  currencyDTO.swift
//  CurrencyConverter
//
//  Created by Grekhem on 20.08.2022.
//

import Foundation

struct CurrencyDTO: Codable {
    let valute: [Valute]
    
    enum CodingKeys: String, CodingKey {
        case valute = "Valute"
    }
}

struct Valute: Codable {
    let numCode, charCode, nominal, name: String
    let value, id: String
    
    enum CodingKeys: String, CodingKey {
        case numCode = "NumCode"
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case id = "ID"
    }
}
