//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Grekhem on 20.08.2022.
//

import Foundation
import UIKit

final class CurrencyCell: UITableViewCell {
    static let id = String(describing: CurrencyCell.self)
    private let id: String
    private var isFavourite: Bool
    private let currencyImage = UIImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.sfProRegular16.font
        label.textColor = AppColor.white.color
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.sfProRegular14.font
        label.textColor = AppColor.green.color
        return label
    }()
    private let heartImageView = UIImageView()
    private let view = UIView()
    private lazy var spacingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 8))
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, id: String, name: String, rate: Double, isFavourite: Bool) {
        self.nameLabel.text = name
        self.id = id
        self.rateLabel.text = String(format: "%.2f", rate) + " RUB"
        self.isFavourite = isFavourite
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurrencyCell {
    func configUi() {
        self.backgroundColor = AppColor.backgroundGray.color
        self.configView()
        self.configCurrencyImage()
        self.configHeartImage()
        self.configRateLabel()
        self.configNameLabel()
        self.configSpacing()
    }
    
    func configView() {
        self.addSubview(view)
        self.view.backgroundColor = .clear
        self.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configCurrencyImage() {
        self.currencyImage.image = UIImage(named: self.id) ?? UIImage(named: "none")
        self.view.addSubview(currencyImage)
        self.currencyImage.snp.makeConstraints { make in
            make.width.height.equalTo(AppConstants.cellCurrencyImageSize).priority(.high)
            make.top.bottom.equalToSuperview().inset(AppConstraints.cellCurrencyImageVertical)
            make.leading.equalToSuperview().offset(AppConstraints.cellCurrencyLeading)
        }
    }
    
    func configHeartImage() {
        if self.isFavourite {
            self.heartImageView.image = UIImage(named: "heart-yes")
        } else {
            self.heartImageView.image = UIImage(named: "heart-no")
        }
        self.view.addSubview(heartImageView)
        self.heartImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppConstraints.cellHeartTrailing).priority(.high)
            make.centerY.equalToSuperview()
        }
    }
    
    func configRateLabel() {
        self.view.addSubview(rateLabel)
        self.rateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(heartImageView.snp.leading).offset(-AppConstraints.cellRateLabelTrailing).priority(.high)
            make.centerY.equalToSuperview()
        }
    }
    
    func configNameLabel() {
        self.view.addSubview(nameLabel)
        self.nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.currencyImage.snp.trailing).offset(AppConstraints.cellNameLeading)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(rateLabel.snp.leading)
        }
    }
    
    func configSpacing() {
        self.spacingView.backgroundColor = .green
        self.addSubview(spacingView)
        self.spacingView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
}
