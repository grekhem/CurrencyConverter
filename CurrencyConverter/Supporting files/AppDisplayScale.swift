//
//  DisplayScale.swift
//  CurrencyConverter
//
//  Created by Grekhem on 19.08.2022.
//

import Foundation
import UIKit

enum AppDisplayScale {
    static let height = UIScreen.main.bounds.height/AppDisplayScale.figmaHeight
    static let width = UIScreen.main.bounds.width/AppDisplayScale.figmaWidth
    private static let figmaHeight: CGFloat = 812
    private static let figmaWidth: CGFloat = 375
}
