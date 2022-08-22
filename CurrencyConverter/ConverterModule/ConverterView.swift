//
//  ConverterView.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

protocol IConverterView: AnyObject {
    var tappedCalculatorButton: ((String) -> Void)? { get set }
    var swipeAmountField: ((Bool) -> Void)? { get set }
    var tapAmountField: ((Bool) -> Void)? { get set }
    var openCurrencyList: (() -> Void)? { get set }
    func changeRateLabel(rate: String)
    func changeAmountField(isRuble: Bool, amount: String)
    func changeOtherCurrencyView(currency: CurrencyEntity)
}

final class ConverterView: UIView {
    var tapAmountField: ((Bool) -> Void)?
    var tappedCalculatorButton: ((String) -> Void)?
    var swipeAmountField: ((Bool) -> Void)?
    var openCurrencyList: (() -> Void)?
    var tabbarHeight: CGFloat = 0
    private let rubleCurrencyView = ConverterCurrencyView(code: "RUB", isRuble: true, currencyId: "rub")
    private var otherCurrencyView = ConverterCurrencyView(code: "USD", isRuble: false, currencyId: "R01235")
    private let gestureChangeCurrencyView = UIView()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.separatorGray.color
        return view
    }()
    private let rateView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.grey.color
        return view
    }()
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = AppFont.sfProRegular16.font
        label.textColor = AppColor.green.color
        return label
    }()
    private let view = UIView()
    private lazy var zeroButton = CalculatorButton(symbol: "0", isZero: true, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var oneButton = CalculatorButton(symbol: "1", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var twoButton = CalculatorButton(symbol: "2", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var threeButton = CalculatorButton(symbol: "3", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var fourButton = CalculatorButton(symbol: "4", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var fiveButton = CalculatorButton(symbol: "5", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var sixButton = CalculatorButton(symbol: "6", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var sevenButton = CalculatorButton(symbol: "7", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var eightButton = CalculatorButton(symbol: "8", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var nineButton = CalculatorButton(symbol: "9", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    private lazy var dotButton = CalculatorButton(symbol: ".", isZero: false, onTapCalculatorButton: self.tapCalculatorButton)
    
    private let firstLineStack = UIStackView()
    private let secondLineStack = UIStackView()
    private let thirdLineStack = UIStackView()
    private let fourthLineStack = UIStackView()
    
    private lazy var rubleSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.rubleDidSwipe(gesture:)))
    private lazy var otherSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.otherDidSwipe(gesture:)))
    private lazy var rubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.rubleDidTap(gesture:)))
    private lazy var otherTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.otherDidTap(gesture:)))
    private lazy var changeCurrencyTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.changeCurrencyTap(gesture:)))
    
    init() {
        super.init(frame: .zero)
        self.configUI()
        self.configGesture()
    }
    
    func updateButtonConstraint() {
        self.view.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(self.tabbarHeight)
        }
    }
    
    private func configGesture() {
        self.rubleCurrencyView.addGestureRecognizer(rubleSwipeGestureRecognizer)
        self.rubleSwipeGestureRecognizer.direction = .right
        self.otherCurrencyView.addGestureRecognizer(otherSwipeGestureRecognizer)
        self.otherSwipeGestureRecognizer.direction = .right
        self.rubleCurrencyView.addGestureRecognizer(rubleTapGesture)
        self.otherCurrencyView.addGestureRecognizer(otherTapGesture)
        self.gestureChangeCurrencyView.addGestureRecognizer(changeCurrencyTapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConverterView: IConverterView {
    func changeOtherCurrencyView(currency: CurrencyEntity) {
        self.otherCurrencyView.changeCurrency(currency: currency)
    }
    
    func changeAmountField(isRuble: Bool, amount: String) {
        if isRuble {
            self.rubleCurrencyView.changeAmountLabel(amount: amount)
        } else {
            self.otherCurrencyView.changeAmountLabel(amount: amount)
        }
    }
    
    func changeRateLabel(rate: String) {
        self.rateLabel.text = rate
    }
}

private extension ConverterView {
    func configUI() {
        self.backgroundColor = AppColor.backgroundGray.color
        self.configStatusBar()
        self.configView()
        self.configRubleView()
        self.configSeparator()
        self.configOtherView()
        self.configRateView()
        self.configRateLabel()
        self.configFirstLineButton()
        self.configSecondLineButton()
        self.configThirdLineButton()
        self.configFourthLineButton()
    }
    
    func configStatusBar() {
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = AppColor.orange.color
        self.addSubview(statusBarView)
    }
    
    func configView() {
        self.addSubview(view)
        self.view.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configRubleView() {
        self.view.addSubview(rubleCurrencyView)
        self.rubleCurrencyView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.rubleCurrencyView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configSeparator() {
        self.view.addSubview(separatorView)
        self.separatorView.snp.makeConstraints { make in
            make.top.equalTo(rubleCurrencyView.snp.bottom)
            make.height.equalTo(AppConstants.separatorHeight)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configOtherView() {
        self.view.addSubview(otherCurrencyView)
        self.otherCurrencyView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.otherCurrencyView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        self.otherCurrencyView.addSubview(gestureChangeCurrencyView)
        self.gestureChangeCurrencyView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width/4)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    func configRateView() {
        self.rateView.backgroundColor = AppColor.grey.color
        self.view.addSubview(rateView)
        self.rateView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.rateView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.rateView.snp.makeConstraints { make in
            make.top.equalTo(otherCurrencyView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configRateLabel() {
        self.rateView.addSubview(rateLabel)
        self.rateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.rateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.rateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(AppConstraints.rateLabelVertical)
            make.centerX.equalToSuperview()
        }
    }
    
    func configFirstLineButton() {
        self.view.addSubview(firstLineStack)
        self.firstLineStack.axis = .horizontal
        self.firstLineStack.distribution = .equalSpacing
        self.firstLineStack.alignment = .center
        self.sevenButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
        self.eightButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
        self.nineButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
        self.firstLineStack.snp.makeConstraints { make in
            make.top.equalTo(rateView.snp.bottom).offset(AppConstraints.lineStackTop)
            make.leading.trailing.equalToSuperview().inset(AppConstraints.lineStackHorizontal)
            make.height.equalTo(AppConstants.calculatorButtonSize)
        }
        self.firstLineStack.addArrangedSubview(sevenButton)
        self.firstLineStack.addArrangedSubview(eightButton)
        self.firstLineStack.addArrangedSubview(nineButton)
    }
    
    func configSecondLineButton() {
        self.view.addSubview(secondLineStack)
        self.secondLineStack.axis = .horizontal
        self.secondLineStack.distribution = .equalSpacing
        self.secondLineStack.alignment = .center
        self.secondLineStack.snp.makeConstraints { make in
            make.top.equalTo(firstLineStack.snp.bottom).offset(AppConstraints.lineStackTop)
            make.leading.trailing.equalToSuperview().inset(AppConstraints.lineStackHorizontal)
            make.height.equalTo(AppConstants.calculatorButtonSize)
        }
        self.secondLineStack.addArrangedSubview(fourButton)
        self.secondLineStack.addArrangedSubview(fiveButton)
        self.secondLineStack.addArrangedSubview(sixButton)
        self.fourButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
        self.fiveButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
        self.sixButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
    }
    
    func configThirdLineButton() {
        self.view.addSubview(thirdLineStack)
        self.thirdLineStack.axis = .horizontal
        self.thirdLineStack.distribution = .equalSpacing
        self.thirdLineStack.alignment = .center
        self.thirdLineStack.snp.makeConstraints { make in
            make.top.equalTo(secondLineStack.snp.bottom).offset(AppConstraints.lineStackTop)
            make.leading.trailing.equalToSuperview().inset(AppConstraints.lineStackHorizontal)
            make.height.equalTo(AppConstants.calculatorButtonSize)
        }
        self.thirdLineStack.addArrangedSubview(oneButton)
        self.thirdLineStack.addArrangedSubview(twoButton)
        self.thirdLineStack.addArrangedSubview(threeButton)
        self.oneButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
        self.twoButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
        self.threeButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
    }
    
    func configFourthLineButton() {
        self.view.addSubview(fourthLineStack)
        self.fourthLineStack.axis = .horizontal
        self.fourthLineStack.distribution = .equalSpacing
        self.fourthLineStack.alignment = .center
        self.fourthLineStack.snp.makeConstraints { make in
            make.top.equalTo(thirdLineStack.snp.bottom).offset(AppConstraints.lineStackTop)
            make.leading.trailing.equalToSuperview().inset(AppConstraints.lineStackHorizontal)
            make.height.equalTo(AppConstants.calculatorButtonSize)
            make.bottom.equalToSuperview().inset(5).priority(.medium)
        }
        self.fourthLineStack.addArrangedSubview(zeroButton)
        self.fourthLineStack.addArrangedSubview(dotButton)
        self.zeroButton.snp.makeConstraints { make in
            make.height.equalTo(AppConstants.calculatorButtonSize)
        }
        self.dotButton.snp.makeConstraints { make in
            make.height.width.equalTo(AppConstants.calculatorButtonSize)
        }
    }
    
    @objc func rubleDidSwipe(gesture: UISwipeGestureRecognizer) {
        self.swipeAmountField?(true)
    }
    
    @objc func rubleDidTap(gesture: UISwipeGestureRecognizer) {
        self.tapAmountField?(true)
    }
    
    @objc func otherDidSwipe(gesture: UISwipeGestureRecognizer) {
        self.swipeAmountField?(false)
    }
    
    @objc func otherDidTap(gesture: UISwipeGestureRecognizer) {
        self.tapAmountField?(false)
    }
    
    @objc func changeCurrencyTap(gesture: UISwipeGestureRecognizer) {
        self.openCurrencyList?()
    }
    
    func tapCalculatorButton(text: String) {
        self.tappedCalculatorButton?(text)
    }
}
