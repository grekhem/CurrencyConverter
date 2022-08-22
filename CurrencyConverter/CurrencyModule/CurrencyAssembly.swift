//
//  CurrencyAssembly.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

enum CurrencyAssembly {
    static func buildModule(arrayOfCurrency: [CurrencyEntity], completion: (((CurrencyEntity) -> Void)?)) -> UIViewController {
        let presenter = CurrencyPresenter(completion: completion)
        let controller = CurrencyViewController(presenter: presenter, arrayOfCurrency: arrayOfCurrency)
        return controller
    }
}
