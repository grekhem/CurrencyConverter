//
//  AppFont.swift
//  CurrencyConverter
//
//  Created by Grekhem on 17.08.2022.
//

import Foundation
import UIKit

enum AppFont {
    case sfProRegular16
    case sfProRegular14
    case sfProRegular32
    case sfProRegular40
    case sfProMedium22
    
    var font: UIFont? {
        switch self {
        case .sfProRegular16:
            return UIFont(name: "SFProDisplay-Regular", size: 16)
        case .sfProRegular32:
            return UIFont(name: "SFProDisplay-Regular", size: 32)
        case .sfProRegular40:
            return UIFont(name: "SFProDisplay-Regular", size: 40)
        case .sfProRegular14:
            return UIFont(name: "SFProDisplay-Regular", size: 14)
        case .sfProMedium22:
            return UIFont(name: "SFProDisplay-Medium", size: 22)
        }
    }
}
