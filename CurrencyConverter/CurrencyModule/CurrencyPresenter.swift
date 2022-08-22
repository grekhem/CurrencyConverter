//
//  CurrencyPresenter.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation

protocol ICurrencyPresenter {
    var dismissVC: (() -> Void)? { get set }
    func viewDidLoad(ui: ICurrencyView)
}

final class CurrencyPresenter {
    var dismissVC: (() -> Void)?
    private var completion: ((CurrencyEntity) -> Void)?
    private weak var ui: ICurrencyView?
    
    init(completion: (((CurrencyEntity) -> Void)?)) {
        self.completion = completion
    }
}

extension CurrencyPresenter: ICurrencyPresenter {
    func viewDidLoad(ui: ICurrencyView) {
        self.ui = ui
        self.ui?.chooseCurrency = { [weak self] currency in
            guard let self = self else { return }
            self.completion?(currency)
            self.dismissVC?()
        }
    }
}
