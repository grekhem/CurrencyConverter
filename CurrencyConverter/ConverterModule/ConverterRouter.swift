//
//  ConverterRouter.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

protocol IConverterRouter: AnyObject {
    func openCurrencyList(arrayOfCurrency: [CurrencyEntity], completion: (((CurrencyEntity) -> Void)?))
}

final class ConverterRouter {
    weak var vc: UIViewController?
}

extension ConverterRouter: IConverterRouter {
    func openCurrencyList(arrayOfCurrency: [CurrencyEntity],completion: (((CurrencyEntity) -> Void)?)) {
        let nextVc = CurrencyAssembly.buildModule(arrayOfCurrency: arrayOfCurrency, completion: completion)
        nextVc.modalTransitionStyle = .flipHorizontal
        nextVc.modalPresentationStyle = .fullScreen
        vc?.present(nextVc, animated: true, completion: nil)
    }
}
