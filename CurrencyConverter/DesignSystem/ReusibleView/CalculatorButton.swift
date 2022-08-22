//
//  CalculatorButton.swift
//  CurrencyConverter
//
//  Created by Grekhem on 17.08.2022.
//

import Foundation
import UIKit

final class CalculatorButton: UIView {
    private var onTapCalculatorButton: ((String) -> Void)?
    private let isZero: Bool
    private let label: UILabel = {
        let label = UILabel()
        label.font = AppFont.sfProRegular40.font
        label.textColor = AppColor.white.color
        return label
    }()
    private lazy var gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
    
    init(symbol: String, isZero: Bool, onTapCalculatorButton: ((String) -> Void)?) {
        self.isZero = isZero
        self.onTapCalculatorButton = onTapCalculatorButton
        super.init(frame: .zero)
        self.label.text = symbol
        self.configUi()
        self.addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
    }
}

private extension CalculatorButton {
    
    func configUi() {
        self.backgroundColor = AppColor.grey.color
        self.addSubview(label)
        self.label.snp.makeConstraints { make in
            if isZero {
                make.leading.equalToSuperview().offset(25)
                make.centerY.equalToSuperview()
            } else {
                make.center.equalToSuperview()
            }
        }
        self.snp.makeConstraints { make in
            if isZero {
                make.width.equalTo(AppConstants.calculatorZeroButtonWidth)
            } else {
                make.width.equalTo(AppConstants.calculatorButtonSize)
            }
        }
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer? = nil) {
        if let text = self.label.text {
            self.onTapCalculatorButton?(text)
        }
    }
}
