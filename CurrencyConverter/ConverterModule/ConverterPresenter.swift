//
//  ConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation

protocol IConverterPresenter {
    var transferArray: (([CurrencyEntity]) -> Void)? { get set }
    func viewDidLoad(ui: IConverterView)
}

final class ConverterPresenter {
    var transferArray: (([CurrencyEntity]) -> Void)?
    private var rubleField = "0"
    private var otherField = "0"
    private var isRubleHighlight = false
    private var interactor: IConverterInteractor?
    private var router: IConverterRouter?
    private weak var ui: IConverterView?
    private var activeCurrencyCode = "USD"
    private var activeCurrencyRate: Double = 0
    private var arrayOfCurrency: [CurrencyEntity] = []
    
    init(interactor: IConverterInteractor, router: IConverterRouter){
        self.router = router
        self.interactor = interactor
        self.interactor?.dataLoaded = dataLoaded(array:)
    }
}

private extension ConverterPresenter {
    func dataLoaded(array: [CurrencyEntity]) {
        self.arrayOfCurrency = array
        self.changeRate()
        self.transferArray?(array)
    }
    
    func changeRate() {
        let currency = self.arrayOfCurrency.filter { item in
            item.charCode == self.activeCurrencyCode
        }
        self.activeCurrencyRate = currency[0].value
        let value = String(format: "%.2f", currency[0].value)
        DispatchQueue.main.async {
            self.ui?.changeRateLabel(rate: "1 \(currency[0].charCode) = \(value) RUB")
        }
    }
    
    func handleCalculatorButton(button: String) {
        if self.isRubleHighlight {
            if self.rubleField != "0" {
                self.rubleField += button
                self.ui?.changeAmountField(isRuble: true, amount: self.rubleField)
                self.changeOtherAmount()
            } else {
                self.rubleField = button
                self.ui?.changeAmountField(isRuble: true, amount: self.rubleField)
                self.changeOtherAmount()
            }
        } else {
            if self.otherField != "0" {
                self.otherField += button
                self.ui?.changeAmountField(isRuble: false, amount: self.otherField)
                self.changeRubleAmount()
            } else {
                self.otherField = button
                self.ui?.changeAmountField(isRuble: false, amount: self.otherField)
                self.changeRubleAmount()
            }
        }
    }
    
    func removeLastChar(isRuble: Bool) {
        if isRuble {
            if self.rubleField.count != 1 {
                self.rubleField.removeLast()
                self.ui?.changeAmountField(isRuble: true, amount: self.rubleField)
                self.changeOtherAmount()
            } else {
                self.rubleField = "0"
                self.otherField = "0"
                self.ui?.changeAmountField(isRuble: true, amount: self.rubleField)
                self.ui?.changeAmountField(isRuble: false, amount: self.otherField)
            }
        } else {
            if self.otherField.count != 1 {
                self.otherField.removeLast()
                self.ui?.changeAmountField(isRuble: false, amount: self.otherField)
                self.changeRubleAmount()
            } else {
                self.otherField = "0"
                self.rubleField = "0"
                self.ui?.changeAmountField(isRuble: false, amount: self.otherField)
                self.ui?.changeAmountField(isRuble: true, amount: self.rubleField)
            }
        }
    }
    
    func changeRubleAmount() {
        if let otherValue = Double(self.otherField) {
            let value = otherValue * activeCurrencyRate
            let string: String = {
                if value == 0 {
                    return "0"
                } else {
                    return String(format: "%.2f", value)
                }
            }()
            self.rubleField = string
            self.ui?.changeAmountField(isRuble: true, amount: self.rubleField)
        }
    }
    
    func changeOtherAmount() {
        if let rubleValue = Double(self.rubleField) {
            let value = rubleValue / activeCurrencyRate
            let string = String(format: "%.2f", value)
            self.otherField = string
            self.ui?.changeAmountField(isRuble: false, amount: self.otherField)
        }
    }
    
    func changeHighlighField(isRuble: Bool) {
        self.isRubleHighlight = isRuble
    }
    
    func openCurrencyList() {
        self.router?.openCurrencyList(arrayOfCurrency: self.arrayOfCurrency) { [weak self] currency in
            guard let self = self else { return }
            self.activeCurrencyCode = currency.charCode
            self.activeCurrencyRate = currency.value
            self.changeRate()
            self.changeRubleAmount()
            self.ui?.changeOtherCurrencyView(currency: currency)
        }
    }
}

extension ConverterPresenter: IConverterPresenter {
    
    func viewDidLoad(ui: IConverterView) {
        self.ui = ui
        self.ui?.tappedCalculatorButton = self.handleCalculatorButton(button:)
        self.ui?.swipeAmountField = self.removeLastChar(isRuble:)
        self.ui?.tapAmountField = self.changeHighlighField(isRuble:)
        self.ui?.openCurrencyList = self.openCurrencyList
    }
}



