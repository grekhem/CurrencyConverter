//
//  ConverterCurrencyView.swift
//  CurrencyConverter
//
//  Created by Grekhem on 17.08.2022.
//

import Foundation
import UIKit
import SnapKit

final class ConverterCurrencyView: UIView {
    private let imageView = UIImageView()
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.sfProRegular32.font
        label.textColor = AppColor.white.color
        label.text = "0"
        return label
    }()
    private let isRuble: Bool
    private let currencyId: String
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.sfProRegular16.font
        label.textColor = AppColor.white.color
        return label
    }()
    
    init(code: String, isRuble: Bool, currencyId: String) {
        self.isRuble = isRuble
        self.currencyId = currencyId
        super.init(frame: .zero)
        self.codeLabel.text = code
        self.configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeAmountLabel(amount: String){
        self.amountLabel.text = amount
    }
    
    func changeCurrency(currency: CurrencyEntity) {
        self.imageView.image = UIImage(named: currency.id) ?? UIImage(named: "none")
        self.codeLabel.text = currency.charCode
    }
}

private extension ConverterCurrencyView {
    func configUI() {
        if self.isRuble {
            self.configRubleCurrencyImage()
            self.configRubleCurrencyCodeLabel()
            self.configRubleCurrencyAmountLabel()
        } else {
            self.configOtherCurrencyImage()
            self.configOtherCurrencyCodeLabel()
            self.configOtherCurrencyAmountLabel()
        }
    }
    
    func configRubleCurrencyImage() {
        self.imageView.image = UIImage(named: currencyId)
        self.addSubview(imageView)
        self.imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppConstraints.currencyImageLeading)
            make.top.equalToSuperview().offset(AppConstraints.currencyImageRubleTop)
            make.height.width.equalTo(AppConstants.currencyImageSize)
        }
    }
    
    func configOtherCurrencyImage() {
        self.imageView.image = UIImage(named: currencyId) ?? UIImage(named: "none")
        self.addSubview(imageView)
        self.imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppConstraints.currencyImageLeading)
            make.top.equalToSuperview().offset(AppConstraints.currencyImageOtherTop)
            make.height.width.equalTo(AppConstants.currencyImageSize)
        }
    }
    
    func configRubleCurrencyCodeLabel() {
        self.codeLabel.text = "RUB"
        self.addSubview(codeLabel)
        self.codeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.codeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.top.equalTo(imageView.snp.bottom).offset(AppConstraints.currencyCodeTop)
            make.bottom.equalToSuperview().inset(AppConstraints.currencyCodeRubleBottom)
        }
    }
    
    func configOtherCurrencyCodeLabel() {
        self.addSubview(codeLabel)
        self.codeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.codeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.top.equalTo(imageView.snp.bottom).offset(AppConstraints.currencyCodeTop)
            make.bottom.equalToSuperview().inset(AppConstraints.currencyCodeOtherBottom)
        }
    }
    
    func configRubleCurrencyAmountLabel() {
        self.addSubview(amountLabel)
        self.amountLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.amountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppConstraints.currencyAmountRubleTop)
            make.trailing.equalToSuperview().inset(AppConstraints.currencyAmountRubleTrailing)
            make.bottom.equalToSuperview().inset(AppConstraints.currencyAmountRubleBottom)
        }
    }
    
    func configOtherCurrencyAmountLabel() {
        self.addSubview(amountLabel)
        self.amountLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.amountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppConstraints.currencyAmountOtherTop)
            make.trailing.equalToSuperview().inset(AppConstraints.currencyAmountRubleTrailing)
            make.bottom.equalToSuperview().inset(AppConstraints.currencyAmountOtherBottom)
        }
    }
}
