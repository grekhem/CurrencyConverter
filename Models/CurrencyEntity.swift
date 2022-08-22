//
//  CurrencyEntity.swift
//  CurrencyConverter
//
//  Created by Grekhem on 20.08.2022.
//

import Foundation

struct CurrencyEntity {
    let id: String
    let numCode: String
    let charCode: String
    let nominal: Int
    let name: String
    let value: Double
    var isFavourite = false
}
