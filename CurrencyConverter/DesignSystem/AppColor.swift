//
//  AppColor.swift
//  CurrencyConverter
//
//  Created by Grekhem on 16.08.2022.
//

import Foundation
import UIKit

enum AppColor {
    case orange
    case grey
    case white
    case separatorGray
    case green
    case backgroundGray
    case textfieldBackground
    
    var color: UIColor {
        switch self {
        case .orange:
            return UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1)
        case .grey:
            return UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        case .white:
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        case .separatorGray:
            return UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        case .green:
            return UIColor(red: 46/255, green: 221/255, blue: 74/255, alpha: 1)
        case .backgroundGray:
            return UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1)
        case .textfieldBackground:
            return UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
        }
    }
}
