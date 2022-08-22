//
//  CurrencyView.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

protocol ICurrencyView: AnyObject {
    var tapBackButton: (() -> Void)? { get set }
    var chooseCurrency: ((CurrencyEntity) -> Void)? { get set }
}

final class CurrencyView: UIView {
    var tapBackButton: (() -> Void)?
    var chooseCurrency: ((CurrencyEntity) -> Void)?
    private var arrayOfCurrency: [CurrencyEntity] = []
    private var filtredArrayOfCurrency: [CurrencyEntity] = []
    private var arrayFavourites: [String] = UserDefaults.standard.stringArray(forKey: "favourites") ?? []
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Currencies"
        label.font = AppFont.sfProMedium22.font
        label.textColor = AppColor.white.color
        return label
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrow"), for: .normal)
        button.addTarget(self, action: #selector(self.onTapBackButton), for: .touchUpInside)
        return button
    }()
    private lazy var searchTextfield: UITextField = {
        let textfield = UITextField()
        textfield.backgroundColor = AppColor.textfieldBackground.color
        textfield.font = AppFont.sfProRegular16.font
        textfield.textColor = AppColor.white.color
        textfield.layer.cornerRadius = 8 * AppDisplayScale.height
        textfield.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                NSAttributedString.Key.font: AppFont.sfProRegular16.font as Any,
                NSAttributedString.Key.foregroundColor: AppColor.white.color
            ]
        )
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        let imageView = UIImageView(frame: CGRect(x: 19, y: -9, width: 16, height: 16))
        imageView.image = UIImage(named: "loupe")
        textfield.leftView?.addSubview(imageView)
        textfield.leftViewMode = .always
        textfield.delegate = self
        textfield.autocorrectionType = .no
        return textfield
    }()
    let network = NetworkService()
    private let tableView = UITableView()
    
    init(arrayOfCurrency: [CurrencyEntity]){
        super.init(frame: .zero)
        self.filtredArrayOfCurrency = arrayOfCurrency
        self.arrayOfCurrency = arrayOfCurrency
        self.checkFavourites()
        self.configUi()
        self.setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CurrencyView: ICurrencyView {}

extension CurrencyView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextfield.resignFirstResponder()
        if textField.text! == "" {
            self.filtredArrayOfCurrency = self.arrayOfCurrency
        } else {
            if let text = textField.text?.lowercased() {
                self.filtredArrayOfCurrency = self.arrayOfCurrency.filter { item in
                    return item.name.lowercased().contains(text) ||
                    item.charCode.lowercased().contains(text)
                }
            }
        }
        self.tableView.reloadData()
        return true
    }
}

extension CurrencyView: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseCurrency?(self.filtredArrayOfCurrency[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Favourites") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            if self.arrayFavourites.contains(self.filtredArrayOfCurrency[indexPath.row].charCode) == false {
                self.addToFavourites(currencyFavourite: self.filtredArrayOfCurrency[indexPath.row], index: indexPath.row)
            } else {
                self.removeFromFavourites(currencyFavourite: self.filtredArrayOfCurrency[indexPath.row], index: indexPath.row)
            }
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

private extension CurrencyView {
    func configUi() {
        self.backgroundColor = AppColor.backgroundGray.color
        self.configBackButton()
        self.configCurrencyLabel()
        self.configSearchTextfield()
        self.configTableView()
    }
    
    func configBackButton() {
        self.addSubview(backButton)
        self.backButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(AppConstraints.currencyBackButtonTop)
            make.leading.equalToSuperview().offset(AppConstraints.currencyBackButtonLeading)
        }
    }
    
    func configCurrencyLabel() {
        self.addSubview(currencyLabel)
        self.currencyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton.snp.centerY)
            make.centerX.equalToSuperview()
        }
    }
    
    func configSearchTextfield() {
        self.addSubview(searchTextfield)
        self.searchTextfield.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(AppConstraints.currencyLabelTop)
            make.leading.trailing.equalToSuperview().inset(AppConstraints.currencyTexfieldHorizontal)
            make.height.equalTo(AppConstraints.currencyTexfieldHeight)
        }
    }
    
    func configTableView() {
        self.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextfield.snp.bottom).offset(AppConstraints.currencyTableViewTop)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupTable() {
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.id)
    }
    
    @objc func onTapBackButton() {
        self.tapBackButton?()
    }
    
    func addToFavourites(currencyFavourite: CurrencyEntity, index: Int) {
        self.arrayFavourites.append(currencyFavourite.charCode)
        UserDefaults.standard.set(self.arrayFavourites, forKey: "favourites")
        self.checkFavourites()
    }
    
    func removeFromFavourites(currencyFavourite: CurrencyEntity, index: Int) {
        if let index = self.arrayFavourites.firstIndex(of: currencyFavourite.charCode) {
            self.arrayFavourites.remove(at: index)
            UserDefaults.standard.set(self.arrayFavourites, forKey: "favourites")
            self.checkFavourites()
        }
    }
    
    func checkFavourites() {
        var array: [CurrencyEntity] = []
        for var item in self.filtredArrayOfCurrency {
            if self.arrayFavourites.contains(item.charCode) {
                item.isFavourite = true
                array.append(item)
            } else {
                item.isFavourite = false
                array.append(item)
            }
        }
        self.filtredArrayOfCurrency = array
        self.arrayOfCurrency = array
        self.tableView.reloadData()
    }
}
