//
//  FavouritePresenter.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation

protocol IFavouritePresenter {
    func viewDidLoad(ui: IFavouriteView)
}

final class FavouritePresenter {
    private var router: IFavouriteRouter?
    private weak var ui: IFavouriteView?
    
    init(router: IFavouriteRouter){
        self.router = router
    }
}

extension FavouritePresenter: IFavouritePresenter {
    func viewDidLoad(ui: IFavouriteView) {
        self.ui = ui
        self.ui?.openCurrencyList = self.router?.openCurrencyList(arrayOfCurrency:)
    }
}
