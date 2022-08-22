//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import UIKit

class ConverterViewController: UIViewController {
    private var presenter: IConverterPresenter
    private var customView = ConverterView()
    
    init(presenter: IConverterPresenter){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let height = self.tabBarController?.tabBar.frame.height {
            self.customView.tabbarHeight = height
            self.customView.updateButtonConstraint()
        }
    }
    
    override func loadView() {
        self.view = customView
        self.presenter.viewDidLoad(ui: self.customView)
        self.presenter.transferArray = { [weak self] array in
            guard let self = self else { return }
            DispatchQueue.main.async {
                (self.tabBarController?.viewControllers?[2] as? FavouriteViewController)?.transferArraOfCurrency(array: array)
            }
        }
    }
}
