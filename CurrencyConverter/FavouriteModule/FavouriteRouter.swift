//
//  FavouriteRouter.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

protocol IFavouriteRouter {
    func openCurrencyList(arrayOfCurrency: [CurrencyEntity])
}

final class FavouriteRouter {
    weak var vc: UIViewController?
}

extension FavouriteRouter: IFavouriteRouter {
    func openCurrencyList(arrayOfCurrency: [CurrencyEntity]) {
        let nextVc = CurrencyAssembly.buildModule(arrayOfCurrency: arrayOfCurrency, completion: nil)
        nextVc.modalTransitionStyle = .flipHorizontal
        nextVc.modalPresentationStyle = .fullScreen
        vc?.present(nextVc, animated: true, completion: nil)
    }
}
