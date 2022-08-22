//
//  CurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import UIKit

class CurrencyViewController: UIViewController {
    private var presenter: ICurrencyPresenter
    private var customView: CurrencyView
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(presenter: ICurrencyPresenter, arrayOfCurrency: [CurrencyEntity]) {
        self.customView = CurrencyView(arrayOfCurrency: arrayOfCurrency)
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        customView.tapBackButton = self.dismissVC
        self.view = customView
        self.configPresenter(ui: self.customView)
    }
    
    private func configPresenter(ui: ICurrencyView) {
        self.presenter.viewDidLoad(ui: self.customView)
        self.presenter.dismissVC = { [weak self] in
            guard let self = self else { return }
            self.dismissVC()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
