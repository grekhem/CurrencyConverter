//
//  FavouriteViewController.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import UIKit

class FavouriteViewController: UIViewController {
    private var presenter: IFavouritePresenter
    private var customView: FavouriteView
    
    override func viewDidAppear(_ animated: Bool) {
        self.customView.checkFavourites()
        if let height = self.tabBarController?.tabBar.frame.height {
            self.customView.tabbarHeight = height
            self.customView.updateButtonConstraint()
        }
    }
    
    init(presenter: IFavouritePresenter) {
        self.customView = FavouriteView()
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.view = customView
        self.configPresenter(ui: self.customView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configPresenter(ui: IFavouriteView) {
        self.presenter.viewDidLoad(ui: self.customView)
    }
    
    func transferArraOfCurrency(array: [CurrencyEntity]) {
        self.customView.updateArrayOfCurrency(array: array)
    }
}
