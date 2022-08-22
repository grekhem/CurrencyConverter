//
//  FavouriteView.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

protocol IFavouriteView: AnyObject {
    var openCurrencyList: (([CurrencyEntity]) -> Void)? { get set }
    func checkFavourites()
}

final class FavouriteView: UIView {
    var openCurrencyList: (([CurrencyEntity]) -> Void)?
    var tabbarHeight: CGFloat = 0
    private var arrayOfCurrency: [CurrencyEntity] = []
    private var favourites = UserDefaults.standard.stringArray(forKey: "favourites")
    private var filtredArrayOfCurrency: [CurrencyEntity] = []
    private let tableView = UITableView()
    private let favouritesLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourites"
        label.font = AppFont.sfProMedium22.font
        label.textColor = AppColor.white.color
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addButton"), for: .normal)
        button.addTarget(self, action: #selector(self.onTapAddButton), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        self.configUi()
        self.setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateArrayOfCurrency(array: [CurrencyEntity]) {
        self.arrayOfCurrency = array
        self.checkFavourites()
    }
    
    func updateButtonConstraint() {
        configAddButton()
    }
}

private extension FavouriteView {
    func configUi() {
        self.backgroundColor = AppColor.backgroundGray.color
        self.configFavouritesLabel()
        self.configTableView()
    }
    
    func configFavouritesLabel() {
        self.addSubview(favouritesLabel)
        self.favouritesLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(AppConstraints.favouriteLabelTop)
            make.centerX.equalToSuperview()
        }
    }
    
    func configTableView() {
        self.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(favouritesLabel.snp.bottom).offset(AppConstraints.favouriteTableVieTop)
            make.leading.trailing.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configAddButton() {
        self.addSubview(addButton)
        self.addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(AppConstraints.favouriteAddButtonBottom + self.tabbarHeight)
            make.trailing.equalToSuperview().inset(AppConstraints.favouriteAddButtonTrailing)
        }
    }
    
    func setupTable() {
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.id)
    }
    
    @objc func onTapAddButton() {
        self.openCurrencyList?(self.arrayOfCurrency)
    }
    
}

extension FavouriteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filtredArrayOfCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurrencyCell(style: .default,
                                reuseIdentifier: CurrencyCell.id,
                                id: self.filtredArrayOfCurrency[indexPath.row].id,
                                name: self.filtredArrayOfCurrency[indexPath.row].name,
                                rate: self.filtredArrayOfCurrency[indexPath.row].value,
                                isFavourite: self.filtredArrayOfCurrency[indexPath.row].isFavourite)
        cell.selectionStyle = .none
        return cell
    }
}

extension FavouriteView: IFavouriteView {
    
    func checkFavourites() {
        self.favourites = UserDefaults.standard.stringArray(forKey: "favourites")
        var array: [CurrencyEntity] = []
        guard let favourites = favourites else { return }
        for var item in self.arrayOfCurrency {
            if favourites.contains(item.charCode) {
                item.isFavourite = true
                array.append(item)
            }
        }
        self.filtredArrayOfCurrency = array
        self.tableView.reloadData()
    }
}
